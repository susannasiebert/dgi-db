class InteractionSearchResultPresenter
  include Genome::Extensions

  attr_accessor :search_term, :interaction_claim, :gene
  def initialize(search_term, gene, interaction_claim)
    @search_term = search_term
    @gene = gene #optional
    @interaction_claim = interaction_claim # optional
  end

  def found_gene?
    # TODO: pass in the gene
    @gene != nil
  end

  def found_interaction?
    @interaction_claim != nil
  end

  def source_db_name
    if found_interaction? 
      @interaction_claim.source.source_db_name
    else
      ''
    end
  end

  def source_db_url
    if found_interaction? 
      @interaction_claim.source.site_url
    else
      ''
    end
  end

  def drug_claim_name
    if found_interaction? 
      @interaction_claim.drug_claim.primary_name || @interaction_claim.drug_claim.name
    else
      'no interactions found!'
    end
  end

  def types_string
    @types_string ||= @interaction_claim
      .interaction_claim_types
      .map{ |x| x.type.sub(/^na$/,'n/a') }
      .join('/')
  end

  def gene_name
    if found_interaction? 
      @interaction_claim.gene_claim.genes.first.name
    elsif found_gene?
      @gene.name
    else
      'no gene found!'
    end
  end

  def gene_long_name
    if found_interaction? 
      @interaction_claim.gene_claim.genes.first.long_name
    elsif found_gene?
      @gene.name
    else
      ''
    end
  end

  def potentially_druggable_categories
    if found_interaction? 
      @interaction_claim.gene_claim
        .genes.first
        .gene_claims
        .flat_map { |gc| gc.gene_claim_categories }
        .map { |c| c.name }
        .uniq
    elsif found_gene?
      @gene
        .gene_claims
        .flat_map { |gc| gc.gene_claim_categories }
        .map { |c| c.name }
        .uniq
    else
      ''
    end
  end
end

