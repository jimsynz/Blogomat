require 'spec_helper'

describe Api::ApiController do
  describe '#index' do
    let(:query) { get :index, format: :json }
    subject { query; response }

    it { should be_success }

    describe 'JSON' do
      subject { query; JSON.parse(response.body) }

      it { should have_key('sessions_url') }
    end
  end
end
