require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

if Fog.mocking?
  describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to :instantiate_vapp_template }

    describe "#instantiate_vapp_template" do
      let(:vdc) { @vcloud.vdcs.first }
      let(:catalog_item) { vdc.catalog.first }
      let(:catalog_item_data) { @vcloud.catalog_item_and_vdc_from_catalog_item_uri(catalog_item.href).first }
      let(:new_vapp_data) do
        {
          :name => "foobar",
          :network_uri => @mock_network[:href],
          :row => "test row",
          :group => "test group",
          :memory => 1024,
          :cpus => 2,
          :vdc_uri => vdc.href
        }
      end
      let(:added_mock_data) { @vcloud.vdc_from_uri(vdc.href)[:vms].last }

      context "with a valid data" do
        let(:template_instantiation) { @vcloud.instantiate_vapp_template(catalog_item.href, new_vapp_data) }
        subject { template_instantiation }

        it_should_behave_like "all responses"
        it { should have_headers_denoting_a_content_type_of "application/xml" }

        it "updates the mock data properly" do
          expect { template_instantiation }.to change { @vcloud.vdc_from_uri(vdc.href)[:vms].count }.by(1)
        end

        describe "added mock data" do
          subject { template_instantiation; added_mock_data }

          it { should include :id }
          it { should include :href }
          it { should include :disks }
          it { should include :ip }

          its(:disks) { should == catalog_item_data[:disks] }

          specify { subject.values_at(*new_vapp_data.keys).should == new_vapp_data.values }
        end

        describe "server based on added mock data" do
          subject { template_instantiation; vdc.servers.reload.detect {|s| s.href == added_mock_data[:href] }.reload }

          its(:name) { should == new_vapp_data[:name] }
        end

        describe "#body" do
          subject { template_instantiation.body }

          it { should have(9).items }

          it_should_behave_like "it has the standard vcloud v0.8 xmlns attributes"   # 3 keys

          its(:href) { should =~ %r{/vapp/\d+$} }
          its(:type) { should == "application/vnd.vmware.vcloud.vApp+xml" }
          its(:name) { should == new_vapp_data[:name] }
          its(:status) { should == "0" }
          its(:size) { should == "4" }

          it { should include :Link }

          describe "Link" do
            subject { template_instantiation.body[:Link] }

            it { should have(3).keys }

            its(:rel)  { should == "up" }
            its(:type) { should == "application/vnd.vmware.vcloud.vdc+xml" }
            its(:href) { should == vdc.href }
          end
        end
      end
    end
  end
else
end
