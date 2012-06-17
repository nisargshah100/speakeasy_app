class Repository < ActiveRecord::Base
  attr_accessible :url
  has_many :events

  after_create :fetch_events

  private

  def fetch_events
    url = self.url.gsub("https://github.com/", "")
    commits = Octokit.commits(url) rescue []
    commits = commits.reverse

    for commit in commits
      self.events.create(:data => { 
        :head_commit => commit,
        :repository => {
          :url => url
        }
      }.to_json)
    end
  end
end
