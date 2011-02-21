require 'ecloud/spec_helper'

if Fog.mocking?
  describe "Fog::Ecloud::Compute::Vdc", :type => :mock_tmrk_ecloud_model do
    subject { @vcloud }

    describe :class do
      subject { Fog::Ecloud::Compute::Server }

      it { should have_identity(:href) }
      it { should have_only_these_attributes([:href, :type, :name, :status, :network_connections, :os, :virtual_hardware, :storage_size, :links]) }
    end

    context "with no uri" do
      subject { Fog::Ecloud::Compute::Server.new() }

      it { should have_all_attributes_be_nil }
    end

    context "as a collection member" do
      subject { @vcloud.vdcs[0].servers.first }

      its(:href)                  { should == @mock_vm.href }
      its(:identity)              { should == @mock_vm.href }
      its(:name)                  { should == @mock_vm.name }
      its(:cpus)                  { should == { :count => @mock_vm.cpus, :units => nil } }
      its(:memory)                { should == { :amount => @mock_vm.memory, :units => nil } }
      its(:disks)                 { should == @mock_vm.to_configure_vapp_hash[:disks] }

      describe "question methods" do
        describe "#ready?" do
          before { subject.power_off }

          it { should be_ready }
        end

        describe "#on?" do
          before { subject.power_on }

          it { should be_on }
        end

        describe "#off?" do
          before { subject.power_off }

          it { should be_off }
        end
      end
    end

    context "as a new server without all info" do
      before { @vcloud.return_vapp_as_creating! "test123" }

      subject { @vcloud.vdcs[0].servers.create(@mock_catalog_item.href, { :name => "test123", :row => "foo", :group => "bar", :network_uri => @mock_network.href }) }

      its(:cpus)                  { should be_nil }
      its(:memory)                { should be_nil }
      its(:disks)                 { should == [] }
    end
  end
else
end
