require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

describe "Fog::Vcloud::Terremark::Ecloud::Vdc", :type => :tmrk_ecloud_model do
  subject { @vcloud }

  it { should respond_to :get_vdc }

  describe :class do
    subject { Fog::Vcloud::Terremark::Ecloud::Vdc }

    it { should have_identity :href }
    it { should have_only_these_attributes [:href, :name, :other_links, :resource_entity_links, :network_links, :cpu_capacity, 
                                            :storage_capacity, :memory_capacity, :vcloud_type, :xmlns, :description,
                                            :deployed_vm_quota, :instantiated_vm_quota] }
  end

  context "with no uri" do

    subject { Fog::Vcloud::Terremark::Ecloud::Vdc.new() }

    its(:href) { should be_nil }
    its(:identity) { should be_nil }
  end

  context "as a collection member" do
    subject { @vcloud.vdcs[0] }

    its(:href)                  { should == URI.parse(@mock_vdc[:href]) }
    its(:identity)              { should == URI.parse(@mock_vdc[:href]) }
    its(:name)                  { should == @mock_vdc[:name] }
    its(:public_ips)            { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::PublicIps }
    its(:other_links)           { should have(4).items }
    its(:resource_entity_links) { should have(3).items }
    its(:network_links)         { should have(2).items }
 
    its(:cpu_capacity)          { should == Struct::VcloudXCapacity.new('hz * 10^6',@mock_vdc[:cpu][:allocated]) }
    its(:memory_capacity)       { should == Struct::VcloudXCapacity.new('bytes * 2^20',@mock_vdc[:memory][:allocated]) }
    its(:storage_capacity)      { should == Struct::VcloudXCapacity.new('bytes * 10^9',@mock_vdc[:storage][:allocated], @mock_vdc[:storage][:used]) }

    its(:deployed_vm_quota)     { should == Struct::VcloudXCapacity.new(nil,nil,-1,-1) }
    its(:instantiated_vm_quota) { should == Struct::VcloudXCapacity.new(nil,nil,-1,-1) }

    its(:public_ips)            { should have(3).public_ips }
    its(:internet_services)     { should have(4).services }
 
  end
end
