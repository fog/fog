require File.dirname(__FILE__) + '/../spec_helper'

describe Fog::Vcloud, :type => :vcloud_request do
  subject { @vcloud }

  it { should respond_to :get_organization }

  describe "#get_organization" do
    context "with a valid organization uri" do
      before { @organization = @vcloud.get_organization(@vcloud.default_organization_uri) }
      subject { @organization }

      it_should_behave_like "all requests"

      its(:headers) { should include "Content-Type" }
      its(:body) { should be_an_instance_of Struct::VcloudOrganization }

      describe :headers do
        let(:header){ @organization.headers["Content-Type"] }
        specify{ header.should == "application/vnd.vmware.vcloud.org+xml" }
      end

      describe "#body" do
        subject { @organization.body }

        it_should_behave_like "it has a vcloud v0.8 xmlns"

        its(:links) { should have(@mock_organization[:vdcs].length * 3).links }
        its(:name) { should == @mock_organization[:info][:name] }
        its(:href) { should == URI.parse(@mock_organization[:info][:href]) }

        let(:link) { subject.links[0] }
        specify { link.should be_an_instance_of Struct::VcloudLink }
        specify { link.rel.should == "down" }
        specify { link.href.should == URI.parse(@mock_vdc[:href]) }
        specify { link.type.should == "application/vnd.vmware.vcloud.vdc+xml" }
        specify { link.name.should == @mock_vdc[:name] }
      end
    end
    context "with an organization uri that doesn't exist" do
      subject { lambda { @vcloud.get_organization(URI.parse('https://www.fakey.com/api/v0.8/org/999')) } }
      it_should_behave_like "a request for a resource that doesn't exist"
    end
  end
end

