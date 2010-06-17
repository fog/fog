require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud::Terremark::Ecloud::Ip", :type => :mock_tmrk_ecloud_model do
    subject { @vcloud }

    describe :class do
      subject { Fog::Vcloud::Terremark::Ecloud::Ip }

      it { should have_identity :href }
      it { should have_only_these_attributes [:href, :name, :status, :server, :rnat, :id] }
    end

    context "with no uri" do

      subject { Fog::Vcloud::Terremark::Ecloud::Ip.new() }
      it { should have_all_attributes_be_nil }

    end

    context "as a collection member" do
      subject        { @vcloud.vdcs[0].networks[0].ips[0].reload; @vcloud.vdcs[0].networks[0].ips[0] }
      let(:status)   { @mock_network[:ips].keys.include?(@vcloud.vdcs[0].networks[0].ips[0].name) ? "Assigned" : nil }
      let(:server)   { @mock_network[:ips][@vcloud.vdcs[0].networks[0].ips[0].name] }

      it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::Ip }

      its(:name)   { should == IPAddr.new(@mock_network[:name]).to_range.to_a[3].to_s }
      its(:status) { should == status }
      its(:server) { should == server }

    end
  end
else
end

