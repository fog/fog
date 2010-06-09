require "spec_helper"

describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :tmrk_ecloud_request do
  subject { @vcloud }

  it { should respond_to :get_network_ips }

  describe "#get_network_ips" do
    context "with a valid VDC network ips_uri" do
      before { @ips = @vcloud.get_network_ips(URI.parse(@mock_network[:href] + "/ips")) }
      subject { @ips }

      it_should_behave_like "all requests"

      its(:headers) { should include "Content-Type" }
      specify { subject.headers['Content-Type'].should == "application/vnd.tmrk.ecloud.ipAddressesList+xml" }

      its(:body) { should be_an_instance_of Struct::TmrkEcloudNetworkIps }

      describe "#body" do
        describe "#addresses" do
          subject { @ips.body.addresses }

          it { should have(252).addresses }

          describe "one we know is assigned" do
            let(:address) { subject[0] }

            specify { address.status.should == "Assigned" }
            specify { address.server.should == "Broom 1" }
            specify { address.name.should == "1.2.3.3" }

          end

          describe "one we know is not assigned" do
            let(:address) { subject[100] }

            specify { address.status.should == "Available" }
            specify { address.server.should == nil }
            specify { address.name.should == "1.2.3.103" }

          end

        end
      end
    end

    context "with a network ips uri that doesn't exist" do
      subject { lambda { @vcloud.get_network_ips(URI.parse('https://www.fakey.c/piv8vc99')) } }

      it_should_behave_like "a request for a resource that doesn't exist"
    end
  end
end
