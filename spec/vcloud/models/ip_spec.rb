require 'vcloud/spec_helper'

if Fog.mocking?
  describe "Fog::Vcloud::Compute::Ip", :type => :mock_vcloud_model do
    subject { @vcloud }

    describe :class do
      subject { Fog::Vcloud::Compute::Ip }

      it { should have_identity(:href) }
      it { should have_only_these_attributes([:href, :name, :status, :server, :id]) }
    end

    context "with no uri" do
      subject { Fog::Vcloud::Compute::Ip.new() }

      it { should have_all_attributes_be_nil }
    end

    context "as a collection member" do
      subject { @ip = @vcloud.vdcs[0].networks[0].ips[0] }

      it { should be_an_instance_of(Fog::Vcloud::Compute::Ip) }

      its(:name) { should == @mock_data.network_ip_from_href(@ip.href).name }
      its(:status) { should == @mock_data.network_ip_from_href(@ip.href).status }
      its(:server) { should == @mock_data.network_ip_from_href(@ip.href).used_by.name }

    end
  end
else
end

