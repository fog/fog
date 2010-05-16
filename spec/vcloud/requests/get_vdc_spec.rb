require "spec_helper"

#
# WARNING: INCOMPLETE
#

describe Fog::Vcloud, :type => :vcloud_request do
  subject { @vcloud }

  it { should respond_to :get_vdc }

  describe :get_vdc, :type => :vcloud_request do
    context "with a valid vdc uri" do
      before { @vdc = @vcloud.get_vdc(URI.parse(@mock_vdc[:href])) }
      subject { @vdc }

      it_should_behave_like "all requests"

      its(:headers) { should include "Content-Type" }
      its(:body) { should be_an_instance_of Struct::VcloudVdc }

      describe :headers do
        let(:header) { @vdc.headers["Content-Type"] }
        specify { header.should == "application/vnd.vmware.vcloud.vdc+xml" }
      end

      describe :body do
        subject { @vdc.body }

        it_should_behave_like "it has a vcloud v0.8 xmlns"

        its(:links) { should have(7).links }
        its(:resource_entities) { should have(3).links }
        its(:networks) { should have(2).networks }

        its(:name) { should == @mock_vdc[:name] }
        its(:href) { should == URI.parse(@mock_vdc[:href]) }

        let(:link) { subject.links[0] }
        specify { link.should be_an_instance_of Struct::VcloudLink }
        specify { link.rel.should == "up" }
        specify { link.href.should == URI.parse(@mock_organization[:info][:href]) }
        specify { link.type.should == "application/vnd.vmware.vcloud.org+xml" }
      end
    end
    context "with a vdc uri that doesn't exist" do
      subject { lambda { @vcloud.get_vdc(URI.parse('https://www.fakey.com/api/v0.8/vdc/999')) } }
      it_should_behave_like "a request for a resource that doesn't exist"
    end
  end
end


