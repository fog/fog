require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to :configure_node }

    describe "#configure_node" do
      let(:original_node) { @vcloud.vdcs.first.public_ips.first.internet_services.first.nodes.first }
      let(:node_data) { { :name => "TEST BOOM", :enabled => "false", :description => "TEST BOOM DESC" } }

      context "with a valid node service uri" do

        subject { @vcloud.configure_node(@mock_node[:href],node_data) }

        it_should_behave_like "all responses"

        describe "#body" do
          subject { @vcloud.configure_node(@mock_node[:href],node_data).body }

          its(:Description) { should == node_data[:description] }
          its(:Href) { should == @mock_node[:href] }
          its(:Name) { should == node_data[:name] }
          its(:Id) { should == @mock_node[:id] }
          its(:Port) { should == @mock_node[:port] }
          its(:Enabled) { should == node_data[:enabled] }
          its(:IpAddress) { should == @mock_node[:ip_address] }
        end

        it "should change the name" do
          original_node.name.should == @mock_node[:name]
          subject
          original_node.reload.name.should == node_data[:name]
        end

        it "should change enabled" do
          original_node.enabled.should == @mock_node[:enabled]
          subject
          original_node.reload.enabled.should == node_data[:enabled]
        end

        it "should change the description" do
          original_node.description.should == @mock_node[:description]
          subject
          original_node.reload.description.should == node_data[:description]
        end
      end

      context "with a nodes uri that doesn't exist" do
        subject { lambda { @vcloud.configure_node(URI.parse('https://www.fakey.c/piv8vc99'), node_data) } }

        it_should_behave_like "a request for a resource that doesn't exist"
      end
    end
  end
else
end
