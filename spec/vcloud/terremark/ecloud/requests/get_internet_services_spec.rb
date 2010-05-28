require "spec_helper"

describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :tmrk_ecloud_request do
  subject { @vcloud }

  it { should respond_to :get_internet_services }

  describe "#get_internet_services" do
    context "with a valid VDC internet_services_uri" do
      before { @services = @vcloud.get_internet_services(URI.parse(@mock_vdc[:href] + "/internetServices")) }
      subject { @services }

      it_should_behave_like "all requests"

      its(:headers) { should include "Content-Type" }
      specify { subject.headers['Content-Type'].should == "application/vnd.tmrk.ecloud.internetServicesList+xml" }

      its(:body) { should be_an_instance_of Struct::TmrkEcloudList }

      describe "#body" do
        describe "#links" do
          subject { @services.body.links }

          it { should have(4).services }

          [0,1,2,3].each do |idx|
            let(:service) { subject[idx] }
            let(:mock_service) { @mock_vdc[:public_ips].map { |ip| ip[:services] }.flatten[idx] }
            let(:mock_ip) { @mock_vdc[:public_ips].detect { |ip| ip[:services].detect { |ipservice| ipservice[:id] == service.id } } }
            specify { service.should be_an_instance_of Struct::TmrkEcloudInternetService }
            specify { service.name.should == mock_service[:name] }
            specify { service.id.should == mock_service[:id] }
            specify { service.href.should == URI.parse(Fog::Vcloud::Terremark::Ecloud::Mock.internet_service_href(mock_service)) }
            specify { service.type.should == "application/vnd.tmrk.ecloud.internetService+xml" }
            specify { service.public_ip.should be_an_instance_of Struct::TmrkEcloudPublicIp }
            specify { service.public_ip.name.should == mock_ip[:name] }
            specify { service.public_ip.id.should == mock_ip[:id] }
            specify { service.public_ip.type.should == "application/vnd.tmrk.ecloud.publicIp+xml" }
            specify { service.port.should == mock_service[:port] }
            specify { service.protocol.should == mock_service[:protocol] }
            specify { service.enabled.should == mock_service[:enabled] }
            specify { service.timeout.should == mock_service[:timeout] }
            specify { service.description.should == mock_service[:description] }
            specify { service.url_send_string.should == nil }
            specify { service.http_header.should == nil }
          end
        end
      end
    end

    context "with a public_ips_uri that doesn't exist" do
      subject { lambda { @vcloud.get_internet_services(URI.parse('https://www.fakey.c/piv8vc99')) } }

      it_should_behave_like "a request for a resource that doesn't exist"
    end
  end
end
