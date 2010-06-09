require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

describe "Fog::Vcloud::Terremark::Ecloud::Network", :type => :tmrk_ecloud_model do
  subject { @vcloud }

  describe :class do
    subject { Fog::Vcloud::Terremark::Ecloud::Network }

    it { should have_identity :href }
    it { should have_only_these_attributes [:href, :name, :features, :configuration, :ips_link, :type, :xmlns] }
  end

  context "with no uri" do

    subject { Fog::Vcloud::Terremark::Ecloud::Network.new() }

    its(:href)          { should be_nil }
    its(:identity)      { should be_nil }
    its(:name)          { should be_nil }
    its(:type)          { should be_nil }
    its(:features)      { should be_nil }
    its(:configuration) { should be_nil }
    its(:ips_link)      { should be_nil }
    its(:xmlns)         { should be_nil }
  end

  context "as a collection member" do
    subject { @vcloud.vdcs[0].networks[0] }

    it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::Network }

    it_should_behave_like "it has a vcloud v0.8 xmlns"

    its(:href)                  { should == URI.parse(@mock_network[:href]) }
    its(:identity)              { should == URI.parse(@mock_network[:href]) }
    its(:name)                  { should == @mock_network[:name] }
    its(:type)                  { should == "application/vnd.vmware.vcloud.network+xml" }

    it { should have(1).features }

    describe :features do
      let(:feature) { subject.features[0] }
      specify { feature.should be_an_instance_of Struct::VcloudNetworkFenceMode }
      specify { feature.mode.should == "isolated" }
    end

    describe :configurations do
      let(:configuration) { subject.configuration }
      specify { configuration.should be_an_instance_of Struct::VcloudNetworkConfiguration }
      specify { configuration.gateway.should == @mock_network[:gateway] }
      specify { configuration.netmask.should == @mock_network[:netmask] }
      specify { configuration.dns.should be_nil }
    end

    describe :ips_link do
      let(:ips_link) { subject.ips_link }
      specify { ips_link.rel.should == "down" }
      specify { ips_link.href.should == URI.parse(@mock_network[:href] + "/ips") }
      specify { ips_link.type.should == "application/xml" }
      specify { ips_link.name.should == "IP Addresses" }
    end

  end
end

