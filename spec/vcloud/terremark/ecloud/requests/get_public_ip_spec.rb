require "spec_helper"

describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :tmrk_ecloud_request do
  subject { @vcloud }

  it { should respond_to :get_public_ip }

  describe "#get_public_ip" do
    context "with a valid public_ip_uri" do
      before do
        @mock_ip = @mock_vdc[:public_ips].first
        @public_ip = @vcloud.get_public_ip(URI.parse("#{@base_url}/extensions/publicIp/#{@mock_ip[:id]}"))
      end

      subject { @public_ip }

      it_should_behave_like "all requests"

      its(:headers) { should include "Content-Type" }
      specify { subject.headers['Content-Type'].should == "application/vnd.tmrk.ecloud.publicIp+xml" }

      its(:body) { should be_an_instance_of Struct::TmrkEcloudPublicIp }

      describe "#body" do
        subject { @public_ip.body }

        its(:name) { should == @mock_ip[:name] }
        its(:href) { should == URI.parse("#{@base_url}/extensions/publicIp/#{@mock_ip[:id]}") }
        its(:id)   { should == @mock_ip[:id] }

      end
    end

    context "with a public_ips_uri that doesn't exist" do
      subject { lambda { @vcloud.get_public_ip(URI.parse('https://www.fakey.c/piv89')) } }

      it_should_behave_like "a request for a resource that doesn't exist"
    end
  end
end
