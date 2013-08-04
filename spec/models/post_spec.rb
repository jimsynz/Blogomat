require 'spec_helper'

describe Post do
  it { should be_a JsonSerializingModel }
  it { should respond_to :subject }
  it { should respond_to :body }
  it { should respond_to :published_at }
  it { should respond_to :user }

  describe '.published' do
    subject { Post.published }
    context "When there are published posts" do
      let(:post) { Fabricate(:published_post) }
      before { post }

      its(:size)  { should eq 1 }
      its(:first) { should eq post }
    end

    context "When there are posts to be published in the future" do
      let(:post) { Fabricate(:pending_post) }
      before { post }

      its(:size)  { should eq 0 }
    end

    context "When there are unpublished posts" do
      let(:post) { Fabricate(:post) }
      before { post }

      its(:size)  { should eq 0 }
    end
  end

  describe '.in_reverse_chronological_order' do
    let(:old_post) { Fabricate(:post, published_at: 3.days.ago) }
    let(:new_post) { Fabricate(:post, published_at: 1.days.ago) }
    before { old_post; new_post }
    subject { Post.in_reverse_chronological_order }

    its(:size)  { should eq 2 }
    its(:first) { should eq new_post }
    its(:last)  { should eq old_post }
  end

  describe '.paginate' do
    before do
      30.times.map do |i|
        Fabricate(:post, published_at: i.days.ago )
      end
    end

    subject { Post.paginate(page_number) }

    context "When I ask for the first page" do
      let(:page_number) { 0 }

      its(:size) { should eq 20 }
    end

    context "When I ask for the second page" do
      let(:page_number) { 1 }

      its(:size) { should eq 10 }
    end

    context "When nil is passed in by accident" do
      let(:page_number) { nil }

      its(:size) { should eq 20 }
    end
  end
end
