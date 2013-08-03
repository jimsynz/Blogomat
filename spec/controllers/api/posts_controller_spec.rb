require 'spec_helper'

describe Api::PostsController do
  let(:json) { JSON.parse(response.body) }

  describe '#index' do
    before do
      request_with_api_token
      10.times.map { |i| Fabricate(:post, published_at: i.days.ago) }
    end
    let(:page_number) { 0 }
    let(:query)       { get :index, format: :json, page_number: page_number }
    subject { query; response }

    its(:status) { should eq 200 }

    describe :json do
      subject { query; json }
      it { should have_key 'posts' }
      describe ['posts'] do
        subject { query; json['posts'] }
        its(:size) { should eq 10 }
      end
    end
  end

  describe '#create' do
    let(:query) { post :create, format: :json, post: post_params }
    let(:post_params) do
      {
        subject:   Faker::Lorem.sentence,
        body:      Faker::Lorem.sentences.join("\n\n"),
        posted_at: Time.now
      }
    end
    subject { query; response }

    context "When there is no signed in user" do
      its(:status) { should eq 401 }

      it { expect{ subject }.not_to change{ Post.all.size }.from(0).to(1) }
    end

    context "When there is a signed in user"  do
      before { sign_in Fabricate(:user) }
      its(:status) { should eq 201 }

      it { expect{ subject }.to change{ Post.all.size }.from(0).to(1) }

      describe :json do
        subject { query; json }

        it { should have_key 'post' }
      end
    end
  end
end
