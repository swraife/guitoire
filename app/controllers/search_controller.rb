class SearchController < ApplicationController
  def search
    @search_results = PgSearch.multisearch(params[:query]).includes(:searchable)
    @search_results = @search_results.select do |result|
      result.searchable.everyone? ||
        (result.searchable_type == 'Group' && current_user.admin_group_ids.include?(result.searchable_id)) ||
        (result.searchable_type == 'Feat' && current_user.admin_feat_ids.include?(result.searchable_id))
    end

    render json: @search_results
  end
end