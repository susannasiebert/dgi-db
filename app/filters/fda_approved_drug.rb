class FdaApprovedDrug
  include Filter
  
  def initialize(checked)
  end

  def cache_key
    "fda_approved_drugs"
  end

  def axis
    :fda_approved_drugs
  end

  def resolve
    Set.new DataModel::Drug
      .where(fda_approved: true)
      .joins(interactions: :interaction_claims)
      .pluck("interaction_claims.id")
  end
end
