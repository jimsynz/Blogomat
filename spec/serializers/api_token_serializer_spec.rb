require 'spec_helper'

describe ApiTokenSerializer do
  let(:token) { ApiToken.new(nil, FakeRedis.new) }
  let(:serializer) { ApiTokenSerializer.new token }
  subject { serializer }

  it { should be_a ApplicationSerializer }

  describe :json do
    subject { serializer.as_json }

    it { should have_key :api_token }

    describe [:api_token] do
      subject { serializer.as_json[:api_token] }

      its([:token]) { should eq token.token }
      its([:ttl])   { should eq token.ttl }

      context "When the token has a related user" do
        let(:user) { Fabricate :user }
        before     { token.user = user }
        its([:user_id]) { should eq user.id }
      end
    end
  end
end
