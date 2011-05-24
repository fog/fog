require 'vcloud/spec_helper'

if Fog.mocking?
  describe "Fog::Vcloud", :type => :mock_vcloud_request do
    subject { @vcloud }

    it { should respond_to(:get_vdc) }

    describe "#get_vdc" do
      context "with a valid vdc uri" do
        before { @vdc = @vcloud.get_vdc(URI.parse(@mock_vdc.href)) }
        subject { @vdc }

        it_should_behave_like "all responses"
        it { should have_headers_denoting_a_content_type_of("application/vnd.vmware.vcloud.vdc+xml") }

        describe "#body" do
          subject { @vdc.body }

          it { should have(11).items }

          it_should_behave_like("it has the standard vcloud v0.8 xmlns attributes")   # 3 keys

          its(:href) { should == @mock_vdc.href }
          its(:name) { should == @mock_vdc.name }

          its(:Description) { should == "" }
          its(:StorageCapacity) { should == {:Units => "bytes * 10^9", :Allocated => @mock_vdc.storage_allocated.to_s, :Used => @mock_vdc.storage_used.to_s } }
          its(:ComputeCapacity) { should == {:InstantiatedVmsQuota => { :Limit => "-1", :Used => "-1" },
                                             :Memory => { :Units => "bytes * 2^20", :Allocated => @mock_vdc.memory_allocated.to_s },
                                             :Cpu => { :Units => "hz * 10^6", :Allocated => @mock_vdc.cpu_allocated.to_s },
                                             :DeployedVmsQuota => { :Limit => "-1", :Used => "-1" } } }

          describe "link 0" do
            subject { @vdc.body[:Link] }
            it { should have(4).attributes }
            its(:type) { should == "application/vnd.vmware.vcloud.catalog+xml" }
            its(:rel)  { should == "down" }
            its(:href) { should == @mock_vdc.catalog.href }
            its(:name) { should == @mock_vdc.catalog.name }
          end

          let(:resource_entities) { subject[:ResourceEntities][:ResourceEntity] }
          specify { resource_entities.should have(@mock_vdc.virtual_machines.length).vapps  }

          describe "[:ResourceEntities][:ResourceEntity]" do
            context "[0]" do
              subject { @vdc.body[:ResourceEntities][:ResourceEntity][0] }
              it { should be_a_vapp_link_to(@mock_vdc.virtual_machines[0]) }
            end
            context "[1]" do
              subject { @vdc.body[:ResourceEntities][:ResourceEntity][1] }
              it { should be_a_vapp_link_to(@mock_vdc.virtual_machines[1]) }
            end
            context "[2]" do
              subject { @vdc.body[:ResourceEntities][:ResourceEntity][2] }
              it { should be_a_vapp_link_to(@mock_vdc.virtual_machines[2]) }
            end
          end

          its(:name)            { should == @mock_vdc[:name] }

          let(:available_networks) { subject[:AvailableNetworks][:Network] }
          specify { available_networks.should have(2).networks }

          describe "[:AvailableNetworks][:Network]" do
            context "[0]" do
              subject { @vdc.body[:AvailableNetworks][:Network][0] }
              it { should be_a_network_link_to(@mock_vdc.networks[0]) }
            end
            context "[1]" do
              subject { @vdc.body[:AvailableNetworks][:Network][1] }
              it { should be_a_network_link_to(@mock_vdc.networks[1]) }
            end
          end
        end
      end

      context "with a vdc uri that doesn't exist" do
        subject { lambda { @vcloud.get_vdc(URI.parse('https://www.fakey.com/api/v0.8/vdc/999')) } }

        it_should_behave_like("a request for a resource that doesn't exist")
      end
    end
  end
end
