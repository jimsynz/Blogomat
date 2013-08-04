require 'spec_helper'

describe Api::UsersController do
  let(:json) { JSON.parse(response.body) }
  before { request_with_api_token }
  subject { query; response }

  shared_examples_for :not_found do
    its(:status) { should eq 404 }
    describe :json do
      subject { query; json }
      it { should have_key 'error' }
    end
  end

  describe '#index' do
    let(:users) { 3.times.map { Fabricate(:user) }}
    before { users }
    let(:query) { get :index, format: :json }

    its(:status) { should eq 200 }
    describe :json do
      subject { query; json }
      it { should have_key 'users' }

      describe ['users'] do
        subject { query; json['users'] }
        its(:size) { should eq 3 }

        describe ['id'] do
          it 'has the ids of all users' do
            query
            expect(json['users'].map { |u| u['id'] }).to eq(users.map(&:id))
          end
        end
      end
    end
  end

  describe '#show' do
    let(:user_id) { user.id }
    let(:query)   { get :show, format: :json, id: user_id }

    context "When the user exists" do
      let(:user)  { Fabricate(:user) }

      its(:status) { should eq 200 }

      describe :json do
        subject { query ; json }

        it { should have_key 'user' }

        describe ['json'] do
          subject { query ; json['user'] }

          its(['id'])     { should eq user.id }
          its(['name'])     { should eq user.name }
          its(['email'])    { should eq user.email }
          its(['username']) { should eq user.username }
        end
      end
    end

    context "When the user doesn't exist" do
      let(:user_id) { rand(99) }

      its(:status) { should eq 404 }
    end
  end
end
