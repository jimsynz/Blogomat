require 'spec_helper'

describe Api::SessionsController do
  subject { query; response }

  shared_examples_for :not_authorized do
    subject { query; response }
    its(:status) { should eq(401) }

    describe 'JSON' do
      subject { query; JSON.parse(response.body) }

      its(['error']) { should eq('not authorized')}
    end
  end

  shared_examples_for :serialized_user do
    describe 'session' do
      subject { query; session }

      it { should have_key :current_user_id }
      its([:current_user_id]) { should eq user.id }
    end

    describe 'JSON' do
      subject { query; JSON.parse(response.body) }

      it { should have_key 'user' }
      its(['user']) { should have_key 'name' }
      its(['user']) { should have_key 'username' }
      its(['user']) { should have_key 'email' }
    end
  end

  describe '#create' do
    let(:query) { post :create, params.merge(format: :json) }

    context "When no parameters are passed" do
      let(:params) { {} }
      it_behaves_like :not_authorized
    end

    context "When a username and password are supplied" do
      let(:username) { 'fakeUser123' }
      let(:password) { 'fakePassword123' }
      let(:params) { { username: username, password: password } }

      context "And the user is not found" do
        it_behaves_like :not_authorized
      end

      context "And the username and password matches a user" do
        let(:user) { Fabricate(:user, username: username, password: password) }
        before { user }

        it { should be_success }
        it_behaves_like :serialized_user
      end
    end
  end

  describe '#index' do
    let(:query) { get :index, format: :json, use_route: :api_sessions }

    context "When there is a signed in user" do
      let(:user) { Fabricate(:user) }
      before { session[:current_user_id] = user.id }

      it { should be_success }
      it_behaves_like :serialized_user
    end

    context "When there is no signed in user" do
      it_behaves_like :not_authorized
    end
  end

  describe '#destroy' do
    let(:query) { delete :destroy, format: :json }

    it { should be_success }

    describe 'session' do
      subject { query; session }

      it { should_not have_key(:current_user_id) }
    end
  end
end
