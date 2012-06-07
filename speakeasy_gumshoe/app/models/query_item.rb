class QueryItem < ActiveRecord::Base
  attr_accessible :content, :query

  define_index do
    indexes query
  end
end
