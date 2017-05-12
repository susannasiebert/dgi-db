module DataModel
  class GeneClaim < ::ActiveRecord::Base
    include Genome::Extensions::UUIDPrimaryKey
    belongs_to :gene
    has_and_belongs_to_many :gene_claim_categories
    has_many :gene_claim_aliases, inverse_of: :gene_claim, dependent: :delete_all
    has_many :gene_claim_attributes, inverse_of: :gene_claim, dependent: :delete_all
    belongs_to :source, inverse_of: :gene_claims, counter_cache: true
    has_many :interaction_claims, inverse_of: :gene_claim
    has_many :drug_claims, through: :interaction_claims

    def self.for_search
      eager_load(gene: [gene_claims: {interaction_claims: { source: [], drug_claim: [:source], interaction_claim_types: [], gene_claim: [gene: [gene_claims: [:gene_claim_categories]]]}}])
    end

    def self.for_gene_categories
      eager_load(gene: [gene_claims: [:source, :gene_claim_categories]])
    end

    def self.for_show
      eager_load(:gene, :source, :gene_claim_aliases, :gene_claim_attributes)
    end

    def self.for_gene_id_mapping
      eager_load(gene: [gene_claims: [:source]])
    end

    def source_db_name
      self.source.source_db_name
    end

    def sort_value
      GeneClaimSortOrder.sort_value(self.source_db_name)
    end

    def original_data_source_url
      base_url = self.source.base_url
      name = self.name
      case self.source.source_db_name
      when 'DrugBank'
        [base_url, 'biodb', 'bio_entities', name].join('/')
      when 'CIViC'
        [base_url, '#', 'events', 'genes', name, 'summary'].join('/')
      when 'PharmGKB'
        [base_url, 'gene', name].join('/')
      when 'TTD'
        base_url + 'Detail.asp?ID=' + name
      when 'GO'
        base_url + name
      when 'GuideToPharmacologyInteractions', 'GuideToPharmacologyGenes'
        'http://www.guidetopharmacology.org/GRAC/ObjectDisplayForward?objectId=' + name
        when 'MyCancerGenome', 'CancerCommons', 'ClearityFoundationBiomarkers', 'ClearityFoundationClinicalTrial',
            'MyCancerGenomeClinicalTrial', 'MskImpact', 'CarisMolecularIntelligence'
        base_url
      else
        base_url + name
      end
    end
  end
end
