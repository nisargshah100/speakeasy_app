require 'spec_helper'

describe AuthService do
  let!(:user) { Fabricate(:user) }
  
  context '#authenticate' do
    context 'valid user' do
      before(:each) do
        @resp = AuthService.authenticate(user.email, 'testing')
      end

      it 'can be authenticated' do
        @resp.email.should == user.email
      end

      it 'returns an auth token' do
        @resp.token.should_not be_nil
        @resp.token.should == user.token
      end
    end

    context 'invalid user' do
      it 'cannot be authenticated' do
        resp = AuthService.authenticate('test', 'one')
        resp.should == nil
      end
    end
  end

  context '#get_user' do
    it 'returns the user if valid token' do
      AuthService.get_user(user.token).id.should == user.id
    end

    it 'returns nil if invalid user' do
      AuthService.get_user('invalid_token').should be_nil
    end
  end
end