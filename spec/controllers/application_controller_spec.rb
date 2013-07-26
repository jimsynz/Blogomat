require 'spec_helper'

describe ApplicationController do
  describe '#signed_in?' do
    subject { controller.signed_in? }

    context "When #current_user is truthy" do
      before { controller.stub(current_user: :yup) }
      it { should be_true }
    end

    context "Otherwise" do
      before { controller.stub(:current_user).and_return(nil) }
      it { should be_false }
    end
  end

  describe '#current_user' do
    subject { controller.current_user }

    context "When there is a real logged in user" do
      let(:user) { Fabricate(:user) }
      before { session[:current_user_id] = user.id }

      it { should eq(user) }
    end

    context "Otherwise" do
      it { should_not be }
    end
  end
end
