require 'spec_helper'

describe Api::UsersController, :type => :api do
  context '#create' do
    let(:valid_user) { 
      {:email => 'test@test.com', :password => 'testing', :name => 'Tester'}
    }

    it 'creates a user' do
      post 'create', { user: valid_user }

      response.status.should == 201
      User.count.should == 1
    end

    it 'requires email' do
      valid_user[:email] = ''
      post 'create', { user: valid_user }

      response.status.should == 400
      JSON.parse(response.body)['email'].should_not be_nil
    end

    it 'requires a unique email' do
      post 'create', { user: valid_user }
      post 'create', { user: valid_user }

      response.status.should == 400
      JSON.parse(response.body)['email'].should_not be_nil
    end

    it 'requires a valid email' do
      valid_user[:email] = 'test@test'
      post 'create', { user: valid_user }

      response.status.should == 400
      JSON.parse(response.body)['email'].should_not be_nil
    end

    it 'requires a password' do
      valid_user[:password] = ''
      post 'create', { user: valid_user }

      response.status.should == 400
      JSON.parse(response.body)['password'].should_not be_nil
    end

    it 'requires a password to be atleast 6 characters long' do
      valid_user[:password] = 'apple'
      post 'create', { user: valid_user }

      response.status.should == 400
      JSON.parse(response.body)['password'].should_not be_nil
    end

    it 'requires a name' do
      valid_user[:name] = ''
      post 'create', { user: valid_user }

      response.status.should == 400
      JSON.parse(response.body)['name'].should_not be_nil
    end

    it 'requires a name to be at maximum 20 characters long' do
      valid_user[:name] = 'a' * 21
      post 'create', { user: valid_user }

      response.status.should == 400
      JSON.parse(response.body)['name'].should_not be_nil
    end
  end

  context '#update' do
    let!(:user) { Fabricate(:user) }

    it 'requires authenticated user' do
      post 'edit'
      response.status.should == 403
    end

    it 'requires the current password' do
      post 'edit', { :token => user.token, :user => { :name => 'Name 2', :password => 'apple' }}
      response.status.should == 400
      JSON.parse(response.body)[0].should match /current password/
    end

    it 'successfully updates the name' do
      post 'edit', { :token => user.token, :user => { :name => 'Name 2', :password => 'testing' }}
      JSON.parse(response.body)['name'].should == 'Name 2'
      user.reload.name.should == 'Name 2'
    end
  end
end
