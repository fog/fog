require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

#FIXME: Make this more sane with rspec2
if Fog.mocking?
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to :delete_internet_service }

    describe "#delete_internet_service" do
      let(:public_ip) { @vcloud.vdcs[0].public_ips[0] }
      let(:before_services) { @vcloud.get_internet_services(public_ip.href) }
      let(:internet_service) { before_services.body[:InternetService].first }

      context "with a valid internet service uri" do
        subject { @vcloud.delete_internet_service( internet_service[:Href] ) }

        it "should have the right count" do
          before_services.body[:InternetService].count.should == 2
        end

        # This actually calls it
        it { should be_an_instance_of Excon::Response }

        it "should remove the service" do
          before_services.body[:InternetService].count.should == 11  #it's now a hash, with 11 keys
        end
      end

    end
  end
else
end

