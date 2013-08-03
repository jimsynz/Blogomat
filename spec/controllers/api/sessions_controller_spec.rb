require 'spec_helper'

describe Api::SessionsController do
  subject { query; response }

  describe '#create' do
    let(:query) { post :create, query_params.merge(format: :json) }

    context "When no parameters are passed" do
      let(:query_params) { {} }
      its(:status) { should eq(201) }
    end

    context "When an incorrect username and password is supplied" do
      let(:query_params) { { username: 'testuser', password: 'testPassword' } }
      its(:status) { should eq(401) }
    end

    context "When an incorrect username and api key is supplied" do
      let(:query_params) { { username: 'testuser', api_key: 'testPassword' } }
      its(:status) { should eq(401) }
    end

    context "When a correct username and password is supplied" do
      let(:password) { MicroToken.generate }
      let(:user)     { Fabricate(:user, password: password) }
      let(:username) { user.username }
      let(:query_params) { { username: username, password: password } }

      its(:status) { should eq(201) }
    end

    context "When a correct username and api key is supplied" do
      let(:user)       { Fabricate(:user) }
      let(:username)   { user.username }
      let(:api_key)    { compute_api_key(username, user.api_secret, current_api_token) }
      let(:query_params) { { username: username, api_key: api_key } }

      context "With an existing api_token" do
        before { request_with_api_token }
        let(:current_api_token) { api_token.token }

        its(:status) { should eq(201) }
      end

      context "Otherwise" do
        let(:current_api_token) { nil }

        its(:status) { should eq(401) }
      end
    end
  end

  describe "#show" do
    subject { get :show, {format: :json} }

    context "When we don't send a current api token" do
      its(:status) { should eq 401 }
    end

    context "When we do send a current api token" do
      before { request_with_api_token }

      its(:status) { should eq 200 }
    end

    context "When we send an expired api token" do
      before do
        api_token.last_seen = 30.minutes.ago
        request_with_api_token
      end

      its(:status) { should eq 401 }
    end
  end

  describe "#destroy" do
    subject { delete :destroy, {format: :json} }

    context "When we don't send a current api token" do
      its(:status) { should eq 401 }
    end

    context "When we do send a current api token" do
      before { request_with_api_token }

      its(:status) { should eq 204 }
    end
  end

end
