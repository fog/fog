require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

if Fog.mocking?
  #FIXME: with rspec2
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to :add_node }

    describe "#add_node" do

      let(:new_node_data) { { :ip_address  => '1.2.3.4',
                              :name        => 'Foo',
                              :port        => '9090',
                              :enabled     => 'true',
                              :description => 'Foo Service'
                            } }

      context "with a valid node services uri" do

        subject { @vcloud.add_node(@mock_service[:href] + "/nodeServices", new_node_data) }

        it_should_behave_like "all responses"

        let(:service) { @vcloud.vdcs.first.public_ips.first.internet_services.first }

        it "should change the count by 1" do
          service.nodes.length.should == 2
          subject
          service.nodes.reload.length.should == 3
        end

        describe "#body" do
          subject { @vcloud.add_node(@mock_service[:href] + "/nodeServices", new_node_data).body }
          its(:Enabled) { should == new_node_data[:enabled] }
          its(:Port) { should == new_node_data[:port] }
          its(:IpAddress) { should == new_node_data[:ip_address] }
          its(:Name) { should == new_node_data[:name] }
          its(:Description) { should == new_node_data[:description] }
        end
      end

      context "with a nodes uri that doesn't exist" do
        subject { lambda { @vcloud.add_node(URI.parse('https://www.fakey.c/piv8vc99'), new_node_data ) } }

        it_should_behave_like "a request for a resource that doesn't exist"
      end
    end
  end
else
end

