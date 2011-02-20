require 'ecloud/spec_helper'

if Fog.mocking?
  describe "Fog::Ecloud::Compute::Node", :type => :mock_tmrk_ecloud_model do

    subject { @vcloud.vdcs.first.public_ips.first.internet_services.first.nodes.first }

    describe :class do
      subject { Fog::Ecloud::Compute::Node }

      it { should have_identity(:href) }
      it { should have_only_these_attributes([:href, :ip_address, :description, :name, :port, :enabled, :id]) }
    end

    context "with no uri" do

      subject { Fog::Ecloud::Compute::Node.new() }
      it { should have_all_attributes_be_nil }

    end

    context "as a collection member" do
      subject { @vcloud.vdcs.first.public_ips.first.internet_services.first.nodes.first.reload }

      it { should be_an_instance_of(Fog::Ecloud::Compute::Node) }

      its(:href)                  { should == @mock_node.href }
      its(:identity)              { should == @mock_node.href }
      its(:name)                  { should == @mock_node.name }
      its(:id)                    { should == @mock_node.object_id.to_s }
      its(:port)                  { should == @mock_node.port.to_s }
      its(:enabled)               { should == @mock_node.enabled.to_s }
      its(:description)           { should == @mock_node.description }

    end
  end
else
end
