require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to :get_vapp }

    describe "#get_vapp" do
      context "with a valid vapp_uri" do
        before { @vapp = @vcloud.get_vapp(vm_data[:href]) }
        subject { @vapp }
        let(:vapp_id) { @vapp.body[:href].split("/").last }
        let(:vm_data) { @vcloud.mock_data[:organizations].first[:vdcs].first[:vms].first }
        let(:vdc) { @vcloud.vdcs.first }

        it_should_behave_like "all responses"
        it { should have_headers_denoting_a_content_type_of "application/vnd.vmware.vcloud.vApp+xml" }

        describe "#body" do
          subject { @vapp.body }

          specify { subject.keys.sort_by(&:to_s).should == [:Link, :NetworkConnectionSection, :OperatingSystemSection, :VirtualHardwareSection, :href, :name, :status, :type, :xmlns, :xmlns_xsd, :xmlns_xsi] }

          it_should_behave_like "it has the standard vcloud v0.8 xmlns attributes"   # 3 keys

          its(:href) { should == vm_data[:href] }
          its(:name) { should == vm_data[:name] }
          its(:status) { should == vm_data[:status].to_s }
          its(:size) { (vm_data[:disks].inject(0) {|s, d| s += d[:size] } * 1024).to_s }

          describe "Link" do
            subject { @vapp.body[:Link] }

            its(:rel)  { should == "up" }
            its(:type) { should == "application/vnd.vmware.vcloud.vdc+xml" }
            its(:href) { should == vdc.href }
          end

          describe "NetworkConnectionSection" do
            subject { @vapp.body[:NetworkConnectionSection] }

            it { should include :NetworkConnection }

            describe "NetworkConnection" do
              subject { @vapp.body[:NetworkConnectionSection][:NetworkConnection] }

              its(:IpAddress) { should == vm_data[:ip] }
            end
          end

          describe "OperatingSystemSection" do
            subject { @vapp.body[:OperatingSystemSection] }

            its(:Info) { should == "The kind of installed guest operating system" }
            its(:Description) { should == "Red Hat Enterprise Linux 5 (64-bit)" }
          end

          describe "VirtualHardwareSection" do
            subject { @vapp.body[:VirtualHardwareSection] }

            specify { subject.keys.sort_by(&:to_s).should == [:Info, :Item, :System, :xmlns] }

            describe "Item" do
              subject { @vapp.body[:VirtualHardwareSection][:Item] }

              it { should have(4).items }

              specify { subject.map {|i| i[:ResourceType] }.sort.should == %w(3 4 6 17).sort }

              describe "CPU" do
                subject { @vapp.body[:VirtualHardwareSection][:Item].detect {|i| i[:ResourceType] == "3" } }

                its(:VirtualQuantity) { should == vm_data[:cpus].to_s }
              end

              describe "memory" do
                subject { @vapp.body[:VirtualHardwareSection][:Item].detect {|i| i[:ResourceType] == "4" } }

                its(:VirtualQuantity) { should == vm_data[:memory].to_s }
              end

              describe "SCSI controller" do
                subject { @vapp.body[:VirtualHardwareSection][:Item].detect {|i| i[:ResourceType] == "6" } }

                its(:Address) { should == "0" }
              end

              describe "Hard Disk 1" do
                subject { @vapp.body[:VirtualHardwareSection][:Item].detect {|i| i[:ResourceType] == "17" } }

                its(:AddressOnParent) { should == "0" }
                its(:VirtualQuantity) { should == (vm_data[:disks].first[:size] * 1024).to_s }
                its(:HostResource)    { should == (vm_data[:disks].first[:size] * 1024).to_s }
              end
            end
          end
        end
      end

      context "with a vapp uri that doesn't exist" do
        subject { lambda { @vcloud.get_vapp(URI.parse('https://www.fakey.com/api/v0.8/vApp/99999')) } }

        it_should_behave_like "a request for a resource that doesn't exist"
      end
    end
  end
else
end
