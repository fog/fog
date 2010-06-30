require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

#FIXME: Make this more sane with rspec2
if Fog.mocking?
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to :delete_internet_service }

    describe "#delete_internet_service" do
      context "with a valid internet service uri" do
        subject { @vcloud.delete_internet_service(@mock_service[:href]) }

        it_should_behave_like "all delete responses"

        let(:public_ip) { @vcloud.vdcs.first.public_ips.first }

        it "should change the count by -1" do
          public_ip.internet_services.length.should == 2
          subject
          public_ip.internet_services.reload.length.should == 1
        end

        describe "#body" do
          its(:body) { should == '' }
        end



      end

    end
  end
else
end

