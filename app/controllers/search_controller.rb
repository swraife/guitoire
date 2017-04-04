class SearchController < ApplicationController
  def search
    @search_results = PgSearch.multisearch(params[:query]).includes(:searchable)
    render json: @search_results, each_serializer: PgSearch::DocumentSerializer
  end
end