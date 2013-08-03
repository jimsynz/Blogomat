require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }
  it { should be_a JsonSerializingModel }

  describe '#api_secret' do
    subject { user.api_secret }

    its(:size) { should eq 128 }
  end

  describe '#password=' do
    let(:new_password) { 'newPassword' }
    before { user.password = new_password }
    subject { user }

    its(:password)       { should match(/^\$2a\$/) }
    its('password.size') { should eq 60 }
  end
end
