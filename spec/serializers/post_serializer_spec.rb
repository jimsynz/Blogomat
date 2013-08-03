require 'spec_helper'

describe PostSerializer do
  let(:post)      { Fabricate(:published_post) }
  let(:serializer) { PostSerializer.new(post) }
  subject { serializer }

  it { should be_an ApplicationSerializer }

  describe '#as_json' do
    subject { serializer.as_json }

    it { should have_key :post }

    describe [:post] do
      subject { serializer.as_json[:post] }

      its([:subject])      { should eq post.subject }
      its([:body])         { should eq post.body }
      its([:published_at]) { should eq post.published_at }
    end
  end
end
