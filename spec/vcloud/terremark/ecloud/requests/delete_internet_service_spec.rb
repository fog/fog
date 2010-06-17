require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    #it { should respond_to :delete_internet_service }

    #describe "#delete_internet_service" do
    #  before do
    #    @public_ip = @vcloud.vdcs[0].public_ips[0]
    #    @before_services = @vcloud.get_internet_services(@public_ip.href)
    #  end

    #  context "with a valid internet service uri" do
    #    subject { @vcloud.delete_internet_service(@before_services.body.tap{|o| pp o}.links[0].href) }
    #
    #    specify { @before_services.body.links.should have(2).links }

    #    it "has the right number of Internet Services after" do
    #      subject
    #      after_services = @vcloud.get_internet_services(@public_ip.href)
    #      after_services.body.links.should have(1).link
    #    end

    #  end

    #  context "with a public_ips_uri that doesn't exist" do
    #    subject { lambda { @vcloud.delete_internet_service(URI.parse('https://www.fakey.c/piv8vc99')) } }

    #    it_should_behave_like "a request for a resource that doesn't exist"
    #  end
    #end
  end
else
end

