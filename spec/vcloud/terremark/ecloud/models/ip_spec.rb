require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

describe "Fog::Vcloud::Terremark::Ecloud::Ip", :type => :tmrk_ecloud_model do
  subject { @vcloud }

  describe :class do
    subject { Fog::Vcloud::Terremark::Ecloud::Ip }

    it { should have_identity :name }
    it { should have_only_these_attributes [:name, :status, :server] }
  end

  context "with no uri" do

    subject { Fog::Vcloud::Terremark::Ecloud::Ip.new() }

    its(:name)   { should be_nil }
    its(:status) { should be_nil }
    its(:server) { should be_nil }
  end

  context "as a collection member" do
    subject        { @vcloud.vdcs[0].networks[0].ips[0] }
    let(:status)   { @mock_network[:ips].keys.include?(@vcloud.vdcs[0].networks[0].ips[0].name) ? "Assigned" : nil }
    let(:server)   { @mock_network[:ips][@vcloud.vdcs[0].networks[0].ips[0].name] }

    it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::Ip }

    its(:name)   { should == IPAddr.new(@mock_network[:name]).to_range.to_a[3].to_s }
    its(:status) { should == status }
    its(:server) { should == server }

  end
end

