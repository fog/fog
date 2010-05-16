require "spec_helper"

describe "Fog::Vcloud, initialized w/ the TMRK Ecloud module", :type => :tmrk_ecloud_request do
  subject { @vcloud }

  it { should respond_to :get_vdc }

  describe "#get_vdc" do
    context "with a valid vdc uri" do
      before { @vdc = @vcloud.get_vdc(URI.parse(@mock_vdc[:href])) }
      subject { @vdc }

      it_should_behave_like "all requests"

      its(:headers) { should include "Content-Type" }
      its(:body) { should be_an_instance_of Struct::TmrkEcloudVdc }

      describe "#headers" do
        let(:header) { @vdc.headers["Content-Type"] }
        specify { header.should == "application/vnd.vmware.vcloud.vdc+xml" }
      end

      describe "#body" do
        subject { @vdc.body }

        it_should_behave_like "it has a vcloud v0.8 xmlns"
        it_should_behave_like "a tmrk vdc"

        it { should respond_to :storage_capacity }
        it { should respond_to :cpu_capacity }
        it { should respond_to :memory_capacity }
        it { should respond_to :deployed_vm_quota }
        it { should respond_to :instantiated_vm_quota }

        its(:name) { should == @mock_vdc[:name] }
        its(:href) { should == URI.parse(@mock_vdc[:href]) }
        its(:description) { should == '' }

        describe "#links" do
          subject { @vdc.body.links }
          it { should have(4).links }

          describe "[0]" do
            subject { @vdc.body.links[0] }
            it_should_behave_like "a vdc catalog link"
          end

          describe "[1]" do
            subject { @vdc.body.links[1] }

            it_should_behave_like "all rel=down vcloud links"
            it_should_behave_like "all tmrk ecloud publicIpList links"

            specify { subject.href.should == URI.parse(@mock_vdc[:href].sub('/vdc','/extensions/vdc') + "/publicIps") }
          end

          describe "[2]" do
            subject { @vdc.body.links[2] }

            it_should_behave_like "all rel=down vcloud links"
            it_should_behave_like "all tmrk ecloud internetServicesList links"

            specify { subject.href.should == URI.parse(@mock_vdc[:href] + "/internetServices") }
          end

          describe "[3]" do
            subject { @vdc.body.links[3] }

            it_should_behave_like "all rel=down vcloud links"
            it_should_behave_like "all tmrk ecloud firewallAclList links"

            specify { subject.href.should == URI.parse(@mock_vdc[:href].sub('/vdc','/extensions/vdc') + "/firewallAcls") }
          end
        end

        describe "#networks" do
          subject { @vdc.body.networks }
          it_should_behave_like "the mocked tmrk network links"
        end

        describe "#storage_capacity" do
          subject { @vdc.body.storage_capacity }

          its(:units) { should == "bytes * 10^9" }
          its(:allocated) { should == @mock_vdc[:storage][:allocated] }
          its(:used) { should == @mock_vdc[:storage][:used] }
        end

        describe "#cpu_capacity" do
          subject { @vdc.body.cpu_capacity }
          its(:units) { should == "hz * 10^6" }
          its(:allocated) { should == @mock_vdc[:cpu][:allocated] }
          its(:used) { should == nil }
          its(:limit) { should == nil }
        end

        describe "#memory_capacity" do
          subject { @vdc.body.memory_capacity }
          it { should be_an_instance_of Struct::VcloudXCapacity }
          its(:units) { should == "bytes * 2^20" }
          its(:allocated) { should == @mock_vdc[:memory][:allocated] }
          its(:used) { should == nil }
          its(:limit) { should == nil }
        end

        describe "#deployed_vm_quota" do
          subject { @vdc.body.deployed_vm_quota }
          it { should be_an_instance_of Struct::VcloudXCapacity }
          its(:limit) { should == -1 }
          its(:used) { should == -1 }
          its(:units) { should == nil }
          its(:allocated) { should == nil }
        end
        describe "#instantiated_vm_quota" do
          subject { @vdc.body.instantiated_vm_quota }
          it { should be_an_instance_of Struct::VcloudXCapacity }
          its(:limit) { should == -1 }
          its(:used) { should == -1 }
          its(:units) { should == nil }
          its(:allocated) { should == nil }
        end
        describe "#resource_entities" do
          subject { @vdc.body.resource_entities }
          it_should_behave_like "the mocked tmrk resource entity links"
        end
      end
    end

    context "with a vdc uri that doesn't exist" do
      subject { lambda { @vcloud.get_vdc(URI.parse('https://www.fakey.com/api/v0.8/vdc/999')) } }

      it_should_behave_like "a request for a resource that doesn't exist"
    end
  end
end
