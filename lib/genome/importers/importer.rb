module Genome
  module Importers
    class Importer
      def import!
        process_file
        store
      end

      private
      def process_file
      end

      def store
        raise 'must implement store!'
      end

      def create_gene_claim_alias(opts = {})
        DataModel::GeneClaimAlias.new.tap do |gca|
          gca.id            = SecureRandom.uuid
          gca.gene_claim_id = opts[:gene_claim_id]
          gca.alias         = opts[:alias]
          gca.nomenclature  = opts[:nomenclature]
          gca.description   = ''
        end
      end

      def create_interaction_claim(opts = {})
        DataModel::InteractionClaim.new.tap do |ic|
          ic.id                = SecureRandom.uuid
          ic.drug_claim_id     = opts[:drug_claim_id]
          ic.gene_claim_id     = opts[:gene_claim_id]
          ic.known_action_type = opts[:known_action_type] || 'unknown'
          ic.source_id         = @source.id
          ic.description       = opts[:description] || ''
          ic.interaction_type  = opts[:interaction_type]
        end
      end

      def create_interaction_claim_attribute(opts = {})
        DataModel::InteractionClaimAttribute.new.tap do |ica|
          ica.id            = SecureRandom.uuid
          ica.interaction_claim_id = opts[:interaction_claim_id]
          ica.name          = opts[:name]
          ica.value         = opts[:value]
        end
      end

      def create_gene_claim(opts = {})
        DataModel::GeneClaim.new.tap do |gc|
          gc.id           = SecureRandom.uuid
          gc.name         = opts[:name]
          gc.nomenclature = opts[:nomenclature]
          gc.source_id    = @source.id
          gc.description  = opts[:description] || ''
        end
      end

      def create_drug_claim(opts = {})
        DataModel::DrugClaim.new.tap do |dc|
          dc.id           = SecureRandom.uuid
          dc.name         = opts[:name]
          dc.nomenclature = opts[:nomenclature]
          dc.source_id    = @source.id
          dc.description  = opts[:description] || ''
          dc.primary_name = opts[:primary_name] || ''
        end
      end

      def create_drug_claim_alias(opts = {})
        DataModel::DrugClaimAlias.new.tap do |dca|
          dca.id            = SecureRandom.uuid
          dca.drug_claim_id = opts[:drug_claim_id]
          dca.alias         = opts[:alias]
          dca.nomenclature  = opts[:nomenclature]
          dca.description   = ''
        end
      end

      def create_drug_claim_attribute(opts = {})
        DataModel::DrugClaimAttribute.new.tap do |dca|
          dca.id            = SecureRandom.uuid
          dca.drug_claim_id = opts[:drug_claim_id]
          dca.name          = opts[:name]
          dca.value         = opts[:value]
          dca.description   = opts[:description] || ''
        end
      end
    end
  end
end