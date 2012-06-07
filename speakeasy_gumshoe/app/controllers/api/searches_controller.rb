class Api::SearchesController < ApplicationController

  def show
    query = params[:query]

    if query
      results = QueryItemDecorator.search(query).map { |i| i.decorate() if i }
    else
      results = {}
    end

    render :json => results
  end

end
