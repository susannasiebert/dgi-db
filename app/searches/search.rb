class Search
  def self.search(search_term)
    raise "You must specify a search term!" if search_term.blank?
    search_term += ":*"

    [].tap do |results|
      results.concat Gene.includes(:gene_claims).advanced_search(name: search_term)
      results.concat Drug.includes(:drug_claims).advanced_search(name: search_term)
      results.concat GeneClaimAlias.includes(gene_claim: [:source]).advanced_search(alias: search_term)
      results.concat DrugClaimAlias.includes(drug_claim: [:source]).advanced_search(alias: search_term)
      results.concat GeneClaim.includes(:source).advanced_search(name: search_term)
      results.concat DrugClaim.includes(:source).advanced_search(name: search_term)
    end.map{ |r| SearchResultPresenter.new(r) }
  end
end
