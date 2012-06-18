require "speakeasy_bouncer_gem/version"
require 'faraday'
require 'hashie'
require 'json'

module SpeakeasyBouncerGem

  def self.conn(url = ENV['BASE_URL'])
    @conn ||= Faraday.new(:url => url)
  end

  def self.authenticate(email, password)
    resp = self.conn.post 'api/users/sessions', { :email => email,
                                                  :password => password }
    resp = get_response(resp)
    Hashie::Mash.new(resp) if resp
  end

  def self.get_user_by_sid(sid)
    self.get_users_by_sid([sid]).first
  end

  def self.get_user(token)
    resp = self.conn.get "api/users/#{token}"
    resp = get_response(resp)
    Hashie::Mash.new(resp) if resp != {}
  end

  def self.user_is_admin?(token)
    get_user(token).is_admin
  end

  def self.get_users_by_sid(sids)
    resp = self.conn.get "api/users/sids/", { :sids => sids.to_json }
    users = get_response(resp)
    users = users.map { |user| user != {} ? Hashie::Mash.new(user) : nil }
  end

  def self.get_user_by_email(email)
    resp = self.conn.get "api/users/email/", { :email => email }
    resp = get_response(resp)
    Hashie::Mash.new(resp) if resp != {}
  end

  private

  def self.get_response(response)
    if response.status == 200 || response.status == 201
      JSON.parse(response.body)
    else
      nil
    end
  end
end
