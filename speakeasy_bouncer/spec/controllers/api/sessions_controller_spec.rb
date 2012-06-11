require 'spec_helper'

describe Api::SessionsController, :type => :api do

  context '#create' do
    let!(:user) { Fabricate(:user) }

    it 'creates a valid authentication' do
      post 'create', {
        :email => user.email,
        :password => 'testing'
      }

      response.status.should == 201
      response.headers["Set-Cookie"].should =~ /user=/
      JSON.parse(response.body)['token'].should == user.token
    end

    it 'denies invalid authentication' do
      post 'create', {
        :email => user.email,
        :password => 'foobar'
      }

      response.status.should == 403
    end
  end

end
