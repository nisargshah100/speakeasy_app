class QueryItemDecorator < Draper::Base
  decorates :query_item

  def as_json(*params)
    JSON.load(model.content) rescue {}
  end
end
