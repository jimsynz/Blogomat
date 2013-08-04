require 'spec_helper'

describe UserSerializer do
  let(:user)  { double(:user) }
  subject { UserSerializer.new(user) }

  it { should respond_to(:id) }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:username) }
end
