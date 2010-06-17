require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud::Terremark::Ecloud::PublicIp", :type => :mock_tmrk_ecloud_model do
    before do
      @mock_ip = @mock_vdc[:public_ips].first
    end

    subject { @vcloud }

    describe :class do
      subject { Fog::Vcloud::Terremark::Ecloud::PublicIp }

      it { should have_identity :href }
      it { should have_only_these_attributes [:name, :id, :href] }
    end

    context "with no uri" do

      subject { Fog::Vcloud::Terremark::Ecloud::PublicIp.new() }

      it { should have_all_attributes_be_nil }
    end

    context "as a collection member" do
      subject { @vcloud.vdcs[0].public_ips[0].reload; @vcloud.vdcs[0].public_ips[0] }

      it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::PublicIp }

      its(:href)                  { should == @mock_ip[:href] }
      its(:identity)              { should == @mock_ip[:href] }
      its(:name)                  { should == @mock_ip[:name] }
      its(:id)                    { should == @mock_ip[:id] }

      its(:internet_services)     { should have(2).services }

    end
  end
else
end
