require File.dirname(__FILE__) + '/../spec_helper'

describe "Fog::Vcloud::Vdc", :type => :vcloud_model do

  describe :class do
    subject { Fog::Vcloud::Vdc }

    it { should have_identity :href }

    it { should have_only_these_attributes [:allocation_model, :cpu_capacity, :description, :enabled, :href, :memory_capacity, :name, :network_links, :network_quota,
                                            :nic_quota, :other_links, :resource_entity_links, :storage_capacity, :vcloud_type, :vm_quota, :xmlns] }
  end

  context "with no uri" do

    subject { Fog::Vcloud::Vdc.new() }

    its(:href) { should be_nil }
    its(:identity) { should be_nil }
  end

  context "as a collection member" do
    subject { @vcloud.vdcs[0] }

    its(:href)                  { should == URI.parse(@mock_vdc[:href]) }
    its(:identity)              { should == URI.parse(@mock_vdc[:href]) }
    its(:name)                  { should == @mock_vdc[:name] }
    its(:other_links)           { should have(7).items }
    its(:resource_entity_links) { should have(3).items }
    its(:network_links)         { should have(2).items }

    its(:cpu_capacity)          { should == Struct::VcloudXCapacity.new('Mhz',@mock_vdc[:cpu][:allocated], nil, @mock_vdc[:cpu][:allocated]) }
    its(:memory_capacity)       { should == Struct::VcloudXCapacity.new('MB',@mock_vdc[:memory][:allocated], nil, @mock_vdc[:memory][:allocated]) }
    its(:storage_capacity)      { should == Struct::VcloudXCapacity.new('MB',@mock_vdc[:storage][:allocated], nil, @mock_vdc[:storage][:allocated]) }

    its(:vm_quota)              { should == 0 }
    its(:nic_quota)             { should == 0 }
    its(:network_quota)         { should == 0 }

    its(:enabled)               { should == true }

  end



end
