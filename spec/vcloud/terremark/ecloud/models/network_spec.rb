require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud::Terremark::Ecloud::Network", :type => :mock_tmrk_ecloud_model do
    subject { @vcloud }

    describe :class do
      subject { Fog::Vcloud::Terremark::Ecloud::Network }

      it { should have_identity :href }
      it { should have_only_these_attributes [:href, :name, :id, :features, :links, :type, :gateway, :broadcast, :address, :rnat, :extension_href] }
    end

    context "with no uri" do

      subject { Fog::Vcloud::Terremark::Ecloud::Network.new() }

      it { should have_all_attributes_be_nil }
    end

    context "as a collection member" do
      subject { @vcloud.vdcs[0].networks[0].reload; @vcloud.vdcs[0].networks[0] }

      it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::Network }

      its(:href)                  { should == @mock_network[:href] }
      its(:identity)              { should == @mock_network[:href] }
      its(:name)                  { should == @mock_network[:name] }
      its(:type)                  { should == "application/vnd.vmware.vcloud.network+xml" }
      its(:id)                    { should == @mock_network[:id] }
      its(:gateway)               { should == @mock_network[:gateway] }
      its(:broadcast)             { should == IPAddr.new(@mock_network[:subnet]).to_range.last.to_s }
      its(:address)               { should == @mock_network[:subnet].split("/")[0] }
      its(:rnat)                  { should == @mock_network[:rnat] }
      its(:extension_href)        { should == @mock_network[:extension_href] }

      it { should have(1).features }

      describe :features do
        let(:feature) { subject.features[0] }
        specify { feature.should be_an_instance_of Hash }
        specify { feature[:FenceMode].should == @mock_network[:features][0][:value] }
      end

      it { should have(2).links }

      describe :links do
        context "[0]" do
          let(:link) { subject.links[0] }
          specify { link[:rel].should == "down" }
          specify { link[:href].should == "#{@mock_network[:href]}/ips" }
          specify { link[:type].should == "application/xml" }
          specify { link[:name].should == "IP Addresses" }
        end

        context "[1]" do
          let(:link) { subject.links[1] }
          specify { link[:rel].should == "down" }
          specify { link[:href].should == @mock_network[:extension_href] }
          specify { link[:type].should == "application/xml" }
          specify { link[:name].should == @mock_network[:name] }
        end
      end

    end
  end
else
end

