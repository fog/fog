require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to :get_internet_services }

    describe "#get_internet_services" do
      context "with a valid VDC internet_services_uri" do
        before { @services = @vcloud.get_internet_services( @mock_vdc[:href] + "/internetServices" ) }
        subject { @services }

        it_should_behave_like "all responses"
        it { should have_headers_denoting_a_content_type_of "application/vnd.tmrk.ecloud.internetServicesList+xml" }

        describe "#body" do
          subject { @services.body }

          it { should have(3).items }

          its(:xmlns) { should == "urn:tmrk:eCloudExtensions-2.3" }
          its(:xmlns_i) { should == "http://www.w3.org/2001/XMLSchema-instance" }

          context "[:InternetService]" do
            subject { @services.body[:InternetService] }

            it { should have(4).items }

            [0,1,2,3].each do |idx|
              let(:service) { subject[idx] }
              let(:mock_service) { @mock_vdc[:public_ips].map { |ip| ip[:services] }.flatten[idx] }
              let(:mock_ip) { @mock_vdc[:public_ips].detect { |ip| ip[:services].detect { |ipservice| ipservice[:id] == service[:Id] } } }
              specify { service.should be_an_instance_of Hash }
              specify { service.should have(11).attributes }
              specify { service[:Name].should == mock_service[:name] }
              specify { service[:Id].should == mock_service[:id] }
              specify { service[:Href].should == Fog::Vcloud::Terremark::Ecloud::Mock.internet_service_href(mock_service) }

              specify { service[:PublicIpAddress].should be_an_instance_of Hash }
              specify { service[:PublicIpAddress].should have(3).attributes }
              specify { service[:PublicIpAddress][:Name].should == mock_ip[:name] }
              specify { service[:PublicIpAddress][:Id].should == mock_ip[:id] }

              specify { service[:Port].should == mock_service[:port] }
              specify { service[:Protocol].should == mock_service[:protocol] }
              specify { service[:Enabled].should == mock_service[:enabled] }
              specify { service[:Timeout].should == mock_service[:timeout] }
              specify { service[:Description].should == mock_service[:description] }
              specify { service[:RedirectURL].should == mock_service[:redirect_url] }
              specify { service[:Monitor].should == "" }
            end
          end
        end
      end

      context "with a valid Public IP uri" do
        before do
          @mock_public_ip = @mock_vdc[:public_ips].first
          @services = @vcloud.get_internet_services( @mock_public_ip[:href] + "/internetServices" ) 
        end
        subject { @services }

        it_should_behave_like "all responses"
        it { should have_headers_denoting_a_content_type_of "application/vnd.tmrk.ecloud.internetServicesList+xml" }

        describe "#body" do
          subject { @services.body }

          it { should have(3).items }

          its(:xmlns) { should == "urn:tmrk:eCloudExtensions-2.3" }
          its(:xmlns_i) { should == "http://www.w3.org/2001/XMLSchema-instance" }

          context "[:InternetService]" do
            subject { @services.body[:InternetService] }

            it { should have(2).items }

            [0,1].each do |idx|
              let(:service) { subject[idx] }
              let(:mock_service) { @mock_public_ip[:services][idx] }
              let(:mock_ip) { @mock_public_ip }
              specify { service.should be_an_instance_of Hash }
              specify { service.should have(11).attributes }
              specify { service[:Name].should == mock_service[:name] }
              specify { service[:Id].should == mock_service[:id] }
              specify { service[:Href].should == Fog::Vcloud::Terremark::Ecloud::Mock.internet_service_href(mock_service) }

              specify { service[:PublicIpAddress].should be_an_instance_of Hash }
              specify { service[:PublicIpAddress].should have(3).attributes }
              specify { service[:PublicIpAddress][:Name].should == mock_ip[:name] }
              specify { service[:PublicIpAddress][:Id].should == mock_ip[:id] }

              specify { service[:Port].should == mock_service[:port] }
              specify { service[:Protocol].should == mock_service[:protocol] }
              specify { service[:Enabled].should == mock_service[:enabled] }
              specify { service[:Timeout].should == mock_service[:timeout] }
              specify { service[:Description].should == mock_service[:description] }
              specify { service[:RedirectURL].should == mock_service[:redirect_url] }
              specify { service[:Monitor].should == "" }
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
else
end
