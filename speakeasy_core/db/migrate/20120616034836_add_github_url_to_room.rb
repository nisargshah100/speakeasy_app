class AddGithubUrlToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :github_url, :string
  end
end
