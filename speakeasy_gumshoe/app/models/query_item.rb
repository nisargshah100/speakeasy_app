class QueryItem < ActiveRecord::Base
  attr_accessible :content, :query, :ns

  define_index do
    indexes query
    indexes ns
  end

  sphinx_scope(:by_ns) do |ns|
    {:conditions => {:ns => ns }}
  end
end
