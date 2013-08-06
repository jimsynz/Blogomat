require 'spec_helper'

describe ApiSessionToken do
  let(:fake_redis)     { FakeRedis.new }
  let(:existing_token) { nil }
  subject { ApiSessionToken.new(existing_token, fake_redis) }

  it { should respond_to :user }
  it { should respond_to :token }
  it { should respond_to :ttl }

  def set_last_seen_to(as_at)
    fake_redis["session_token/#{existing_token}/last_seen"] = as_at.iso8601
  end

  def set_last_user_to(user)
    ApiSessionToken.new(existing_token, fake_redis).user = user
  end

  shared_examples_for :fresh_token do
    its(:token)        { should be_present }
    its(:last_seen)    { should be_within(2.seconds).of(Time.now) }
    its(:ttl)          { should be_within(2).of(1200) }
    its(:expired?)     { should be_false }
  end

  context "When creating a new token" do
    its(:user)      { should be_nil }
    it_behaves_like :fresh_token
  end

  context "When refreshing an existing (not expired) token" do
    let(:existing_token) { ApiSessionToken.new(nil,fake_redis).token }
    before { set_last_seen_to 2.minutes.ago }

    its(:user)      { should be_nil }
    it_behaves_like :fresh_token
  end

  context "When refreshing an existing (expired) token" do
    let(:existing_token) { ApiSessionToken.new(nil,fake_redis).token }
    before { set_last_seen_to 30.minutes.ago }

    it { should be_expired }
    its(:ttl) { should eq 0 }
  end

  context "When storing a user" do
    let(:user) { Fabricate(:user) }

    context "When refreshing an existing (not expired) token" do
      let(:existing_token) { ApiSessionToken.new(nil,fake_redis).token }
      before do
        set_last_user_to user
        set_last_seen_to 2.minutes.ago
      end

      its(:user)      { should eq user }
      it_behaves_like :fresh_token
    end

    context "When refreshing an existing (expired) token" do
      let(:existing_token) { ApiSessionToken.new(nil,fake_redis).token }
      before do
        set_last_user_to user
        set_last_seen_to 30.minutes.ago
      end

      it { should be_expired }
      its(:user) { should be_nil }
      its(:ttl)  { should eq 0 }
    end
  end

  describe "#delete" do
    let(:token) { ApiSessionToken.new(nil, fake_redis) }
    before { token }

    it "deletes the session keys from redis" do
      expect { token.delete! }.to change { fake_redis.dbsize }.to(0)
    end

    it "behaves as if its expired" do
      expect { token.delete! }.to change { token.expired? }.from(false).to(true)
    end

    it "behaves as if its ttl is zero" do
      expect { token.delete! }.to change { token.ttl }.to(0)
    end
  end
end
