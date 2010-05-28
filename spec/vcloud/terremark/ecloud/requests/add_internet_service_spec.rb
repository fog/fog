require "spec_helper"

describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :tmrk_ecloud_request do
  subject { @vcloud }

  it { should respond_to :add_internet_service }

  describe "#add_internet_service" do
    before do
      @public_ip = @vcloud.vdcs[0].public_ips[0]
      @new_service_data = { :name => "Test Service",
                            :protocol => "HTTP",
                            :port => "80",
                            :enabled => "true",
                            :description => "this is a test" }
    end

    context "with a valid Public IP uri" do
      it "has the right number of Internet Services before" do
        before_services = @vcloud.get_internet_services(@public_ip.href)
        before_services.body.links.should have(2).links
      end

      subject { @vcloud.add_internet_service(@public_ip.href.to_s + "/internetServices", @new_service_data ) }

      it "has the right number of Internet Services after" do
        subject
        @vcloud.get_internet_services(@public_ip.href).body.links.should have(3).links
      end

      it_should_behave_like "all requests"

      let(:body) { subject.body }

      its(:body) { should be_an_instance_of Struct::TmrkEcloudInternetService }
      specify { body.href.to_s.should == Fog::Vcloud::Terremark::Ecloud::Mock.internet_service_href( { :id => 372 } ) }
      specify { body.name.should == "Test Service" }
      specify { body.protocol.should == "HTTP" }
      specify { body.enabled.should == true }
      specify { body.description.should == "this is a test" }

      let(:public_ip) { subject.body.public_ip }
      specify { public_ip.should be_an_instance_of Struct::TmrkEcloudPublicIp }
      specify { public_ip.name.should == @public_ip.name }
      specify { public_ip.id.should == @public_ip.id }
      specify { public_ip.type.should == "application/vnd.tmrk.ecloud.publicIp+xml" }

    end

    context "with a public_ips_uri that doesn't exist" do
      subject { lambda { @vcloud.add_internet_service(URI.parse('https://www.fakey.c/piv8vc99'), @new_service_data ) } }

      it_should_behave_like "a request for a resource that doesn't exist"
    end
  end
end

