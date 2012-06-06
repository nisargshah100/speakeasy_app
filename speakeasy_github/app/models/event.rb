require 'hashie'

class Event < ActiveRecord::Base
  attr_accessible :data, :repo_url

  def data
    Hashie::Mash.new(JSON.load(read_attribute(:data)))
  end
end
