class RenameHabtmTablesForRails4 < ActiveRecord::Migration
  def change
    rename_table :drug_claim_types_drug_claims, :drug_claim_types_claims
    rename_table :gene_claim_categories_gene_claims, :gene_claim_categories_claims
    rename_table :interaction_claim_types_interaction_claims, :interaction_claim_types_claims
  end
end
