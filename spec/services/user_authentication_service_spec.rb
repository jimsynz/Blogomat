require 'spec_helper'

describe UserAuthenticationService do

  describe '.authenticate_with_password' do
    let(:password) { 'fakePassword123' }
    let(:user)     { Fabricate(:user, password: password) }
    let(:password_try) { nil }
    subject { UserAuthenticationService.authenticate_with_password(user, password_try) }

    context "When the password is correct" do
      let(:password_try) { 'fakePassword123' }

      it { should be_true }
    end

    context "When the password is not correct" do
      let(:password_try) { 'wrongPassword' }

      it { should be_false }
    end

    context "When the user doesn't exist" do
      let(:user) { nil }

      it { should be_false }
    end
  end

  describe '.authenticate_with_api_key' do
    let(:api_secret) { 's3kr1t' }
    let(:user)    { Fabricate(:user, api_secret: api_secret) }
    subject { UserAuthenticationService.authenticate_with_api_key(user, key_try) }

    context "When the api key is incorrect" do
      let(:key_try) { 'wrongKey' }

      it { should be_false }
    end

    context "When the api key is correct" do
      let(:user)    { Fabricate(:user, username: 'known_value', api_secret: api_secret) }
      let(:key_try) { '54d3b4a131c01ca20c0c60276c8db65cc0d3bd542b3fd1f4132d28b4d5ef7d09' }

      it { should be_true }
    end

    context "When the user doesn't exist" do
      let(:user) { nil }
      let(:key_try) { 'fakeKey123' }

      it { should be_false }
    end
  end

  describe '.authenticate_with_password!' do
    let(:user) { Fabricate(:user, password: MicroToken.generate) }

    context "When authentication fails" do
      it "raises NotAuthorized" do
        expect { UserAuthenticationService.authenticate_with_password!(user, 'test') }.to raise_error(UserAuthenticationService::NotAuthorized)
      end
    end
  end

  describe '.authenticate_with_api_key!' do
    let(:user) { Fabricate(:user) }

    context "When authentication fails" do
      it "raises NotAuthorized" do
        expect { UserAuthenticationService.authenticate_with_api_key!(user, 'test') }.to raise_error(UserAuthenticationService::NotAuthorized)
      end
    end
  end
end
