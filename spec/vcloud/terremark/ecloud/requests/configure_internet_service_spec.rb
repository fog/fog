require "spec_helper"

describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :tmrk_ecloud_request do
  subject { @vcloud }

  it { should respond_to :configure_internet_service }

  describe "#configure_internet_service" do
    before do
      @public_ip = @vcloud.vdcs[0].public_ips[0]
      @original_service = @vcloud.get_internet_services(@public_ip.href).body.links.first
      @service_data = {}
      @original_service.each_pair { |sym, data| @service_data[sym] = data }
      @ip_data = { :id => @public_ip.id, :name => @public_ip.name, :href => @public_ip.href.to_s }
    end

    context "with a valid Internet Service uri and valid data" do

      subject { @vcloud.configure_internet_service(@original_service.href, @service_data, @ip_data) }

      it_should_behave_like "all requests"

      context "with some changed data" do
        before do
          @service_data[:description] = "TEST BOOM"
        end
        it "should change data" do
          @original_service.description.should == "Web Servers"
          result = subject
          result.body.description.should == "TEST BOOM"
          @vcloud.get_internet_services(@public_ip.href).body.links.first.description.should == "TEST BOOM"
        end
      end

    end

    context "with an internet_services_uri that doesn't exist" do
      subject { lambda { @vcloud.configure_internet_service(URI.parse('https://www.fakey.c/piv8vc99'), @service_data, @ip_data ) } }

      it_should_behave_like "a request for a resource that doesn't exist"
    end
  end
end

