require "spec_helper"

describe "Fog::Vcloud, initialized w/ the TMRK Vcloud module", :type => :tmrk_vcloud_request do
  subject { @vcloud }

  it { should respond_to :get_vdc }

  describe :get_vdc do
    context "with a valid vdc uri" do
      before { @vdc = @vcloud.get_vdc(@mock_vdc[:href]) }
      subject { @vdc }

      it_should_behave_like "all requests"

      its(:headers) { should include "Content-Type" }
      its(:body) { should be_an_instance_of Struct::TmrkVcloudVdc }

      describe :headers do
        let(:header) { @vdc.headers["Content-Type"] }
        specify { header.should == "application/vnd.vmware.vcloud.vdc+xml" }
      end

      describe :body do
        subject { @vdc.body }

        it_should_behave_like "it has a vcloud v0.8 xmlns"
        it_should_behave_like "a tmrk vdc"

        its(:name) { should == @mock_vdc[:name] }
        its(:href) { should == @mock_vdc[:href] }

        describe "#links" do
          subject { @vdc.body.links }
          it { should have(3).links }

          describe "#link[0]" do
            subject { @vdc.body.links[0] }
            it_should_behave_like "a vdc catalog link"
          end

          describe "#link[1]" do
            subject { @vdc.body.links[1] }

            it_should_behave_like "all rel=down vcloud links"
            it_should_behave_like "all vcloud application/xml types"
            specify { subject.href.should == @mock_vdc[:href] + "/publicIps" }
          end

          describe "#link[2]" do
            subject { @vdc.body.links[2] }

            it_should_behave_like "all rel=down vcloud links"
            it_should_behave_like "all vcloud application/xml types"
            specify { subject.href.should == @mock_vdc[:href] + "/internetServices" }
          end
        end
        describe :networks do
          subject { @vdc.body.networks }
          it_should_behave_like "the mocked tmrk network links"
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
