Fabricator(:drug) do
  name { sequence(:name) { |i| "Drug ##{i}" } }
end

Fabricator(:drug_claim) do
  name { sequence(:name) { |i| "Drug Claim ##{i}" } }
  description ''
  source
  nomenclature { |attrs| "#{attrs[:source].source_db_name} drug claim name" }
  primary_name { sequence(:primary_name) { |i| "Drug claim primary name ##{i}" } }
end

Fabricator(:drug_claim_alias) do |f|
  f.alias { sequence(:alias) { |i| "Drug Claim Alias ##{i}" } }
  f.description ''
  f.nomenclature { sequence(:nomenclature) { |i| "Drug Claim Alias nomenclature ##{i}" } }
end

Fabricator(:drug_claim_attribute) do
  name { sequence(:name) { |i| "Drug Claim Attribute Name ##{i}" } }
  value { sequence(:value) { |i| "Drug Claim Attribute Value ##{i}" } }
  description ''
end

Fabricator(:drug_claim_type) do
  type { ['antineoplastic', ''].sample }
end