class InteractionSearchResultsPresenter
  include Genome::Extensions
  attr_reader :search_results

  def initialize(search_results, start_time)
    @start_time = start_time
    @search_results = search_results
  end

  def number_of_search_terms
    @search_results.count
  end

  def number_of_definite_matches
    @search_results.select{ |r| r.genes.count == 1 }.count
  end

  def number_of_ambiguous_matches
    @search_results.select{ |r| r.genes.count > 1 }.count
  end

  def number_of_no_matches
    @search_results.select{ |r| r.genes.count == 0 }.count
  end

  def number_of_definite_interactions
   definite_interactions.count
  end

  def number_of_ambiguous_interactions
   ambiguous_interactions.count
  end

  def number_of_search_terms_with_at_least_one_interaction
    @search_results.select{ |x| x.interaction_claims.count > 0 }.count
  end

  def all_interactions
    @all_interactions ||= interaction_result_presenters(@search_results)
  end

  def ambiguous_results
    Maybe(grouped_results[:ambiguous])
  end

  def definite_results
    Maybe(grouped_results[:definite])
  end

  def no_results_results
    Maybe(grouped_results[:no_results])
  end

  def ambiguous_no_interactions
    Maybe(grouped_results[:ambiguous_no_interactions])
  end

  def definite_no_interactions
    Maybe(grouped_results[:definite_no_interactions])
  end

  def time_elapsed(context)
   context.instance_exec(@start_time) do |start_time|
     distance_of_time_in_words(start_time, Time.now, true)
   end
  end

  def definite_interactions
    @definite_interactions ||= interaction_result_presenters(definite_results)
  end

  def ambiguous_interactions
    @ambiguous_interactions ||= interaction_result_presenters(ambiguous_results)
  end

  def show_definite?
    !grouped_results[:definite].nil?
  end

  def show_ambiguous?
    !grouped_results[:ambiguous].nil?
  end

  def show_no_results_results?
    !grouped_results[:no_results].nil?
  end

  def show_ambiguous_no_interactions?
    !grouped_results[:ambiguous_no_interactions].nil?
  end

  def show_definite_no_interactions?
    !grouped_results[:definite_no_interactions].nil?
  end

  def each_result(context)
    @search_results.each do |result|
      yield OpenStruct.new(
        search_term: result.search_term,
        match_type: result.match_type_label,
        matches_with_links: (result.genes.map do |g|
          context.instance_exec{ link_to g.name, gene_path(g.name) }
        end.join(", ") + " ").html_safe)
    end
  end

  def source_db_names_for_table
    definite_interactions
      .flat_map { |i| i.source_db_name }
      .uniq
      .sort
  end

  def interactions_map_by_source_db_names
    unless @interactions_map_by_source_db_names
      interaction_groups =
        definite_interactions.inject(Hash.new() {|hash, key| hash[key] = []}) do |hash, presenter|
          hash.tap do |h|
            name = [presenter.drug_claim_name, presenter.gene_name].join(" and ")
            h[name] << presenter
          end
        end
      @interactions_map_by_source_db_names = interaction_groups.inject([]) do |array, (name, gene)|
        gene_sources = gene.map{|g| g.source_db_name}
        array << OpenStruct.new(
          name: name,
          sources: source_db_names_for_table.map{ |s| gene_sources.include?(s) }
        )
      end
    end
    @interactions_map_by_source_db_names
  end

  def interactions_by_gene
    unless @interactions_by_gene
      interactions_by_gene = definite_interactions.inject(Hash.new() {|hash, key| hash[key] = []}) do |hash, presenter|
        hash[presenter.gene_name] << presenter
        hash
      end
      gene_names = interactions_by_gene.keys.uniq
      @interactions_by_gene = gene_names.inject([]) do |array, gene_name|
        presenters = interactions_by_gene[gene_name]
        array << OpenStruct.new(
          search_term: presenters.first.search_term,
          gene_name: gene_name,
          gene_display_name: presenters.first.gene_long_name,
          drug_count: interactions_by_gene[gene_name]
            .map{ |i| i.drug_claim_name }.uniq.count,
          category_list: presenters.first.potentially_druggable_categories
        )
      end
    end
    @interactions_by_gene
  end

  private
  def grouped_results
    @grouped_results ||= @search_results.group_by { |result| result.partition }
  end

  def interaction_result_presenters(result_list)
    # passes search_term, gene (if found), interaction (if found)
    rows = result_list.flat_map do |result|
      if result.genes.length == 0
        OpenStruct.new(term: result.search_term, gene: nil, interaction: nil)
      else
        if result.interaction_claims.length == 0 
          result.genes.map do |gene|
            OpenStruct.new(term: result.search_term, gene: gene, interaction: nil)
          end
        else
          result.interaction_claims.map do |interaction|
            OpenStruct.new(term: result.search_term, gene: interaction.gene_claim.genes.first, interaction: interaction)
          end
        end
      end
    end.sort do |a,b|
      a.term <=> b.term or
      a.gene.name <=> b.gene.name
    end

    term_gene_count = {}
    term_gene_n = {}
    last_term = ''
    last_gene = ''
    rows.each do |row|
      if ! term_gene_n.has_key?(row.term)
        # new term
        term_gene_n[row.term] = { row.gene => 1 }
        term_gene_count[row.term] = 1
      else
        if ! term_gene_n[row.term].has_key?(row.gene)
          # old term new gene
          term_gene_count[row.term] = term_gene_count[row.term]+1 
          term_gene_n[row.term][row.gene] = term_gene_count[row.term] 
        else
          # old term old gene
        end
      end
    end
    rows.map do |row|
      gene_n = term_gene_n[row.term][row.gene]
      gene_count = term_gene_count[row.term]
      show_term = if gene_count <= 1 then row.term else row.term + ' (' + gene_n.to_s + ' of ' + gene_count.to_s + ')' end
      InteractionSearchResultPresenter.new(show_term,row.gene,row.interaction)
    end
  end
end

