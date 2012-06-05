require 'drb'

class User < ActiveRecord::Base
  include DRbUndumped

  authenticates_with_sorcery!
  attr_accessible :email, :name, :as => [:default, :admin]
  attr_accessible :password, :as => :admin

  uniquify :token, :length => 24

  validates :email, :presence => true,
                    :email => true,
                    :uniqueness => true

  validates :password, :presence => true,
                       :length => { :minimum => 6 }

  validates :name, :presence => true,
                   :length => { :maximum => 20 }
end
