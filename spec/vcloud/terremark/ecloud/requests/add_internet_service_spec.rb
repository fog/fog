require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to :add_internet_service }

    describe "#add_internet_service" do
      before do
        @public_ip = @vcloud.vdcs[0].public_ips[0]
        @new_service_data = { :name => "Test Service",
                              :protocol => "HTTP",
                              :port => "80",
                              :enabled => "true",
                              :description => "this is a test",
                              :redirect_url => "" }
      end

      context "with a valid Public IP uri" do
        it "has the right number of Internet Services before" do
          before_services = @vcloud.get_internet_services(@public_ip.href)
          before_services.body[:InternetService].should have(2).services
        end

        subject { @vcloud.add_internet_service(@public_ip.href.to_s + "/internetServices", @new_service_data ) }

        it "has the right number of Internet Services after" do
          subject
          @vcloud.get_internet_services(@public_ip.href).body[:InternetService].should have(3).services
        end

        it_should_behave_like "all responses"

        let(:body) { subject.body }

        its(:body) { should be_an_instance_of Hash }
        specify { body[:Href].should == Fog::Vcloud::Terremark::Ecloud::Mock.internet_service_href( { :id => 372 } ) }
        specify { body[:Name].should == @new_service_data[:name] }
        specify { body[:Protocol].should == @new_service_data[:protocol] }
        specify { body[:Enabled].should == @new_service_data[:enabled] }
        specify { body[:Description].should == @new_service_data[:description] }
        specify { body[:RedirectURL].should == @new_service_data[:redirect_url] }
        specify { body[:Monitor].should == nil }

        let(:public_ip) { subject.body[:PublicIpAddress] }
        specify { public_ip.should be_an_instance_of Hash }
        specify { public_ip[:Name].should == @public_ip.name }
        specify { public_ip[:Id].should == @public_ip.id }

      end

      context "with a public_ips_uri that doesn't exist" do
        subject { lambda { @vcloud.add_internet_service(URI.parse('https://www.fakey.c/piv8vc99'), @new_service_data ) } }

        it_should_behave_like "a request for a resource that doesn't exist"
      end
    end
  end
else
end

