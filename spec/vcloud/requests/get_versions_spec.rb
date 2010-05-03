require 'spec_helper'

describe Fog::Vcloud, :type => :vcloud_request do
  subject { @vcloud }

  it { should respond_to :get_versions }

  describe "#get_versions" do
    before { @versions = @vcloud.get_versions }
    subject { @versions }

    it_should_behave_like "all requests"

    its(:body) { should have(1).version }

    describe "body.first" do
      let(:version) { @versions.body.first }
      subject { version }

      its(:login_url) { should == @mock_version[:login_url] }

      its(:version) { should == @mock_version[:version] }

      its(:supported) { should == @mock_version[:supported] }

    end
  end
end
