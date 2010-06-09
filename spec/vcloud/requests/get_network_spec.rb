require "spec_helper"

describe Fog::Vcloud, :type => :vcloud_request do
  subject { @vcloud }

  it { should respond_to :get_network }

  describe :get_network, :type => :vcloud_request do
    context "with a valid network uri" do
      before { @network = @vcloud.get_network(URI.parse(@mock_network[:href])) }
      subject { @network }

      it_should_behave_like "all requests"

      its(:headers) { should include "Content-Type" }
      its(:body) { should be_an_instance_of Struct::VcloudNetwork }

      describe :headers do
        let(:header) { @network.headers["Content-Type"] }
        specify { header.should == "application/vnd.vmware.vcloud.network+xml" }
      end

      describe :body do
        subject { @network.body }

        it_should_behave_like "it has a vcloud v0.8 xmlns"

        its(:configuration) { should be_an_instance_of Struct::VcloudNetworkConfiguration }
        its(:features)      { should be_an_instance_of Array }
        its(:href)          { should == URI.parse("https://fakey.com/api/v0.8/network/31") }
        its(:type)          { should == "application/vnd.vmware.vcloud.network+xml" }
        its(:name)          { should == @mock_network[:name] }
        its(:description)   { should == @mock_network[:name] }

        describe :configuration do
          subject { @network.body.configuration }

          its(:gateway) { should == "1.2.3.1" }
          its(:netmask) { should == "255.255.255.0" }
          its(:dns)     { should == "8.8.8.8" }
        end

        describe "FenceMode Feature" do
          subject { @network.body.features.detect { |feature| feature.is_a?(Struct::VcloudNetworkFenceMode) } }
          its(:mode) { should == "isolated" }
        end

      end
    end
    context "with a network uri that doesn't exist" do
      subject { lambda { @vcloud.get_network(URI.parse('https://www.fakey.com/api/v0.8/network/999')) } }
      it_should_behave_like "a request for a resource that doesn't exist"
    end
  end
end
