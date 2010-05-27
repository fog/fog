require "spec_helper"

describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :tmrk_ecloud_request do
  subject { @vcloud }

  it { should respond_to :get_public_ips }

  describe "#get_public_ips" do
    context "with a valid public_ips_uri" do
      before { @public_ips = @vcloud.get_public_ips(URI.parse(@mock_vdc[:href] + "/publicIps")) }
      subject { @public_ips }

      it_should_behave_like "all requests"

      its(:headers) { should include "Content-Type" }
      specify { subject.headers['Content-Type'].should == "application/vnd.tmrk.ecloud.publicIpsList+xml" }

      its(:body) { should be_an_instance_of Struct::TmrkEcloudPublicIpList }

      describe "#body" do
        describe "#links" do
          subject { @public_ips.body.links }

          it { should have(3).ips }

          [0,1,2].each do |idx|
            let(:ip) { subject[idx] }
            let(:mock_ip) { @mock_vdc[:public_ips][idx] }
            specify { ip.should be_an_instance_of Struct::TmrkEcloudPublicIp }
            specify { ip.name.should == mock_ip[:name] }
            specify { ip.id.should == mock_ip[:id] }
            specify { ip.href.should == URI.parse("https://fakey.com/api/v0.8/extensions/publicIp/#{mock_ip[:id]}") }
          end
        end
      end
    end

    context "with a public_ips_uri that doesn't exist" do
      subject { lambda { @vcloud.get_public_ips(URI.parse('https://www.fakey.c/piv8vc99')) } }

      it_should_behave_like "a request for a resource that doesn't exist"
    end
  end
end
