class StaticController < ApplicationController
  before_filter :set_active

  def search_categories
    @current_sources = Source.all_sources
    @sources         = Source.potentially_druggable_source_names
    @gene_categories = GeneClaimCategory.all_category_names
    @source_trust_levels = SourceTrustLevel.all_trust_levels
  end

  def search_interactions
    prepare_available_filter_actions
    @current_sources = Source.all_sources
  end

  def news
    cookies[:most_recent_post_date] = NewsFilter.most_recent_post_date.to_s
    @news.mark_read!
  end

  private
  @@help_pages = Set.new ['getting_started', 'news', 'faq', 'downloads', 'contact', 'api']
  def set_active
    @@help_pages.include?(params[:action]) ? instance_variable_set("@help_active", "active") : instance_variable_set("@#{params[:action]}_active", "active")
  end

  def prepare_available_filter_actions
    @sources             = Source.source_names_with_interactions
    @drug_types          = DrugClaimType.all_type_names
    @gene_categories     = GeneClaimCategory.all_category_names
    @interaction_types   = InteractionClaimType.all_type_names
    @source_trust_levels = SourceTrustLevel.all_trust_levels
  end

end
