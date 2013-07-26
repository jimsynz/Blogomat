require 'spec_helper'

describe UserAuthenticationService do

  let(:username) { 'fakeUser123' }
  let(:password) { 'fakePassword123' }
  let(:user)     { double(:user, username: username, password: BCrypt::Password.create(password)) }

  subject { described_class.new(user, password) }

  it { should respond_to(:user) }
  it { should respond_to(:password) }

  describe '.authenticate' do
    it 'creates a new instance' do
      expect(UserAuthenticationService).to receive(:new).with(user, password).and_call_original
      UserAuthenticationService.authenticate(user, password)
    end

    it 'calls authenticate on the instance' do
      expect_any_instance_of(UserAuthenticationService).to receive(:authenticate)
      UserAuthenticationService.authenticate(user, password)
    end
  end

  describe '#authenticate' do
    subject { described_class.new(user,guess).authenticate }

    context "When the password matches" do
      let(:guess) { password }
      it { should be_true }
    end

    context "When the password is incorrect" do
      let(:guess) { 'fail$$$' }

      it { should be_false }
    end
  end
end
