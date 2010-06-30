require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

if Fog.mocking?
  #FIXME: with rspec2
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to :delete_node }

    describe "#delete_node" do
      context "with a valid node service uri" do
        subject { @vcloud.delete_node(@mock_node[:href]) }

        #it_should_behave_like "all delete responses"

        let(:internet_service) { @vcloud.vdcs.first.public_ips.first.internet_services.first }

        it "should change the count by -1" do
          internet_service.nodes.length.should == 2
          subject
          internet_service.nodes.reload.length.should == 1
        end
      end

      context "with a nodes uri that doesn't exist" do
        subject { lambda { @vcloud.delete_node(URI.parse('https://www.fakey.c/piv8vc99')) } }

        it_should_behave_like "a request for a resource that doesn't exist"
      end
    end
  end
else
end

