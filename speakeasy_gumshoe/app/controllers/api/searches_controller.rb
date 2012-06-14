class Api::SearchesController < ApplicationController

  def show
    query = params[:query]
    ns = params[:ns]

    if query and ns
      results = QueryItemDecorator.by_ns(ns).search(query).map do |i| 
        i.decorate() if i
      end
    else
      results = {}
    end

    render :json => results
  end

end
