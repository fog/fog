require File.join(File.dirname(__FILE__), '..', 'spec_helper')

if Fog.mocking?
  describe Fog::Vcloud, :type => :mock_vcloud_request do
    subject { @vcloud }

    it { should respond_to :get_versions }

    describe "#get_versions" do
      before { @versions = @vcloud.get_versions( @vcloud.versions_uri ) }
      subject { @versions }

      it_should_behave_like "all responses"

      describe "body" do
        subject { @versions.body }

        it { should have(4).keys }
        it_should_behave_like "it has the standard xmlns attributes"   # 2 keys

        its(:xmlns) { should == "http://www.vmware.com/vcloud/versions" }
        its(:VersionInfo) { should == { :LoginUrl => @mock_version[:login_url] , :Version => @mock_version[:version] } }

      end
    end
  end
else
end
