Fabricator(:gene) do
  name { sequence(:name) { |i| "Gene ##{i}" } }
  long_name { sequence(:long_name) { |i| "Gene ##{i} long name" } }
end

Fabricator(:gene_claim) do
  name { sequence(:name) { |i| "Gene Claim ##{i}" } }
  description ''
  nomenclature { |attrs| "#{attrs[:source].source_db_name} gene claim name" }
  nomenclature { sequence(:nomenclature) { |i| "Gene claim ##{i} nomenclature" } }
end

Fabricator(:gene_claim_alias) do |f|
  f.alias { sequence(:alias) { |i| "Gene Claim Alias ##{i}" } }
  f.description ''
  f.nomenclature { sequence(:nomenclature) { |i| "Gene Claim Alias nomenclature ##{i}" } }
end

Fabricator(:gene_claim_attribute) do
  name { sequence(:name) { |i| "Gene Claim Attribute Name ##{i}" } }
  value { sequence(:value) { |i| "Gene Claim Attribute Value ##{i}" } }
  description ''
end

Fabricator(:gene_claim_category) do
  name { sequence(:gene_claim_category) { |i| "Gene Claim Category ##{i}" } }
end

Fabricator(:gene_gene_interaction_claim)

Fabricator(:gene_gene_interaction_claim_attribute) do
  name { sequence(:gene_gene_interaction_claim_attribute_name) { |i| "Inter gene interaction ##{i} name" } }
  value { sequence(:gene_gene_interaction_claim_attribute_value) { |i| "Inter gene interaction ##{i} value" } }
end
