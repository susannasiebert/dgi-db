require 'spec_helper'

describe Genome::Groupers::DrugGrouper do

  def create_drug_aliases
    drug_source = Fabricate(:source, source_db_name: 'pubchem')
    drug_claims = (1..3).map { Fabricate(:drug_claim, source: drug_source) }
    drug_claims.each do |drug_claim|
      Fabricate(:drug_claim_alias, drug_claim: drug_claim, nomenclature: 'Drug Synonym')
    end
    drug_claims
  end     
  
  it 'should group by DrugBank with same alias' do
    drug_source = Fabricate(:source, source_db_name: 'DrugBank')
    grouped_dbank_drug_claims = (1..3).map { Fabricate(:drug_claim, source: drug_source) }
    grouped_dbank_drug_claims.each do |drug_claim|
      Fabricate(:drug_claim_alias, alias: 'Test Drugbank Drug', drug_claim: drug_claim, nomenclature: 'DrugBank Drug Name')
    end

    Genome::Groupers::DrugGrouper.run 
    
    expect(grouped_dbank_drug_claims.first.drugs).not_to be_empty
  end

  it 'should group by DrugBank with different aliases' do
    drug_source = Fabricate(:source, source_db_name: 'DrugBank')
    grouped_dbank_drug_claims = (1..3).map { Fabricate(:drug_claim, source: drug_source) }
    grouped_dbank_drug_claims.each do |drug_claim|
      Fabricate(:drug_claim_alias, drug_claim: drug_claim, nomenclature: 'DrugBank Drug Name')
    end

    Genome::Groupers::DrugGrouper.run 
    d_arr = Array.new
    grouped_dbank_drug_claims.each do |d|
      d_arr.push(d.name)
    end
    uniq_arr = d_arr.uniq
    
    expect(d_arr.size()).to eq uniq_arr.size()
  end
  
  it 'should add drug claims if there were no direct matches and one indirect match' do
    grouped_drug_claims = create_drug_aliases
    test_name = 'test drug name'
    Fabricate(:drug_claim_alias, alias: test_name, drug_claim: grouped_drug_claims.first)

    ungrouped_drug_claim = Fabricate(:drug_claim)
    Fabricate(:drug_claim_alias, alias: test_name, drug_claim: ungrouped_drug_claim)

    Genome::Groupers::DrugGrouper.run

    drug = grouped_drug_claims.first.drugs.first
    grouped_drug = ungrouped_drug_claim.drugs.first

    expect(drug).to eq grouped_drug  
  end
end
