require 'spec_helper'

describe ApplicationSerializer do
  subject { described_class.new(double) }
  it { should be_a ActiveModel::Serializer }
end
