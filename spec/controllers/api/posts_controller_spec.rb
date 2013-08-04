require 'spec_helper'

describe Api::PostsController do
  let(:json) { JSON.parse(response.body) }
  subject { query; response }

  shared_examples_for :not_found do
    its(:status) { should eq 404 }
    describe :json do
      subject { query; json }
      it { should have_key 'error' }
    end
  end

  shared_examples_for :post do
    describe :json do
      subject { query; json }
      it      { should have_key 'post' }

      describe ['post'] do
        subject { query; json['post'] }
        it      { should have_key 'id' }
      end

      describe ['post', 'id'] do
        subject { query; json['post']['id'] }
        it      { should eq post_id }
      end
    end
  end

  describe '#index' do
    before do
      request_with_api_token
      10.times { |i| Fabricate(:post, published_at: i.days.ago) }
    end
    let(:page_number) { 0 }
    let(:query)       { get :index, format: :json, page_number: page_number }

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

  describe '#show' do
    let(:query)   { get :show, format: :json, id: post_id }
    let(:post_id) { _post.id }
    before { request_with_api_token }

    context "When requesting a published post" do
      let(:_post) { Fabricate(:published_post) }
      its(:status) { should eq 200 }
      it_behaves_like :post
    end

    context "When requesting a not-yet published post" do
      let(:user)  { nil }
      let(:_post) { Fabricate(:pending_post, user: user) }

      context "When the requesting user is the author" do
        let(:user) { Fabricate(:user) }
        before { sign_in user }
        its(:status) { should eq 200 }
        it_behaves_like :post
      end

      context "Otherwise" do
        it_behaves_like :not_found
      end
    end

    context "When requesting a non-existant post" do
      let(:post_id) { rand(99) }
      it_behaves_like :not_found
    end
  end

  describe '#update' do
    let(:query) { patch :update, format: :json, id: post_id, post: post_params }
    let(:new_subject) { 'Updated subject'}
    let(:post_params) { { subject: new_subject } }
    let(:post_id) { _post.id }
    before { request_with_api_token }

    context "When updating my own post" do
      let(:user)    { Fabricate(:user) }
      let(:_post)   { Fabricate(:post, user: user) }
      before        { sign_in user }

      its(:status) { should eq 200 }
      it_behaves_like :post
      it 'updates the subject' do
        query
        expect(json['post']['subject']).to eq(new_subject)
      end
    end

    context "When updating someone else's post" do
      let(:user)    { Fabricate(:user) }
      let(:_post)   { Fabricate(:post) }
      before        { sign_in user }

      it_behaves_like :not_found
    end

    context "When updating a non-existant post" do
      let(:post_id) { rand(99) }

      it_behaves_like :not_found
    end
  end

  describe "#destroy" do
    let(:query)   { delete :destroy, format: :json, id: post_id }
    let(:_post)   { Fabricate(:post) }
    let(:post_id) { _post.id }
    before        { request_with_api_token }

    context "When deleting my own post" do
      let(:user) { _post.user }
      before     { sign_in user }

      its(:status) { should eq 204 }
    end

    context "When deleting someone else's post" do
      let(:user) { Fabricate(:user) }
      before     { sign_in user }

      it_behaves_like :not_found
    end

    context "When deleting a non-existant post" do
      let(:post_id) { rand(99) }

      it_behaves_like :not_found
    end
  end
end
