require 'hashie'

class Event < ActiveRecord::Base
  attr_accessible :data, :repo_url

  def data
    Hashie::Mash.new(JSON.load(read_attribute(:data)))
  end

  def self.fetch_for(url)
    url = url.gsub("https://github.com/", "")
    commits = Octokit.commits(url) rescue []

    for commit in commits
    end
  end
end
