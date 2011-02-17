require 'ecloud/spec_helper'

if Fog.mocking?
  describe "Fog::Ecloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to(:add_backup_internet_service) }

    describe "#add_backup_internet_service" do
      before do
        @new_backup_service_data = {
          :name => "Test Service",
          :protocol => "HTTP",
          :enabled => "true",
          :description => "this is a test",
          :redirect_url => ""
        }
      end

      context "with a valid vdc uri" do
        subject { @vcloud.add_backup_internet_service(@mock_vdc.internet_service_collection.href, @new_backup_service_data ) }

        it "has the right number of Internet Services after" do
          expect { subject }.to change { @vcloud.get_internet_services(@mock_vdc.internet_service_collection.href).body[:InternetService].size }.by(1)
        end

        it_should_behave_like "all responses"

        let(:body) { subject.body }

        its(:body) { should be_an_instance_of(Hash) }
        specify { body[:Href].should_not be_empty }
        specify { body[:Name].should == @new_backup_service_data[:name] }
        specify { body[:Protocol].should == @new_backup_service_data[:protocol] }
        specify { body[:Enabled].should == @new_backup_service_data[:enabled] }
        specify { body[:Description].should == @new_backup_service_data[:description] }
        specify { body[:RedirectURL].should == @new_backup_service_data[:redirect_url] }
        specify { body[:Monitor].should == nil }
        # so broken
        specify { body[:IsBackupService].should == "false" }

        it "should update the mock object properly" do
          subject

          backup_internet_service = @vcloud.mock_data.backup_internet_service_from_href(body[:Href])
          backup_internet_service.object_id.to_s.should == body[:Id]
          backup_internet_service.node_collection.items.should be_empty
        end
      end

      context "with a vdc uri that doesn't exist" do
        subject { lambda { @vcloud.add_backup_internet_service(URI.parse('https://www.fakey.c/piv8vc99'), @new_backup_service_data ) } }

        it_should_behave_like "a request for a resource that doesn't exist"
      end
    end
  end
else
end

