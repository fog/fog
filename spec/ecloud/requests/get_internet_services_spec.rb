require 'ecloud/spec_helper'

if Fog.mocking?
  shared_examples_for "a basic internet service" do
    specify { service.should be_an_instance_of(Hash) }
    specify { service.should have(14).attributes }
    specify { service[:Name].should == mock_service.name }
    specify { service[:Id].should == mock_service.object_id.to_s }
    specify { service[:Href].should == mock_service.href }

    specify { service[:PublicIpAddress].should be_an_instance_of(Hash) }
    specify { service[:PublicIpAddress].should have(3).attributes }
    specify { service[:PublicIpAddress][:Name].should == mock_ip.name }
    specify { service[:PublicIpAddress][:Href].should == mock_ip.href }
    specify { service[:PublicIpAddress][:Id].should == mock_ip.object_id.to_s }

    specify { service[:Port].should == mock_service.port.to_s }
    specify { service[:Protocol].should == mock_service.protocol }
    specify { service[:Enabled].should == mock_service.enabled.to_s }
    specify { service[:Timeout].should == mock_service.timeout.to_s }
    specify { service[:Description].should == mock_service.description }
    specify { service[:RedirectURL].should == (mock_service.redirect_url || "") }
    specify { service[:Monitor].should == "" }
    specify { service[:IsBackupService].should == "false" }
    specify { service[:BackupOf].should == "" }
  end

  shared_examples_for "an internet service without a backup internet service set" do
    specify { service[:BackupService].should be_nil }
  end

  shared_examples_for "an internet service with a backup internet service set" do
    specify { service[:BackupService].should be_an_instance_of(Hash) }
    specify { service[:BackupService].should include(:Href) }
    specify { service[:BackupService][:Href].should == @mock_backup_service.href }
  end

  shared_examples_for "a backup internet service" do
    specify { service.should be_an_instance_of(Hash) }
    specify { service.should have(14).attributes }
    specify { service[:Name].should == mock_service.name }
    specify { service[:Id].should == mock_service.object_id.to_s }
    specify { service[:Href].should == mock_service.href }

    specify { service[:PublicIpAddress].should be_nil }

    specify { service[:Port].should == mock_service.port.to_s }
    specify { service[:Protocol].should == mock_service.protocol }
    specify { service[:Enabled].should == mock_service.enabled.to_s }
    specify { service[:Timeout].should == mock_service.timeout.to_s }
    specify { service[:Description].should == mock_service.description }
    specify { service[:RedirectURL].should == (mock_service.redirect_url || "") }
    specify { service[:Monitor].should be_nil }
    specify { service[:IsBackupService].should == "true" }
    specify { service[:BackupService].should be_nil }
    specify { service[:BackupOf].should == "" }
  end

  describe "Fog::Ecloud, initialized w/ the TMRK Ecloud module", :type => :mock_tmrk_ecloud_request do
    subject { @vcloud }

    it { should respond_to(:get_internet_services) }

    describe "#get_internet_services" do
      context "with a valid VDC internet_services_uri" do
        before do
          @mock_vdc.internet_service_collection.items[3][:backup_service] = @mock_backup_service
          @services = @vcloud.get_internet_services(@mock_vdc_service_collection.href)
        end

        subject { @services }

        it_should_behave_like "all responses"
        it { should have_headers_denoting_a_content_type_of("application/vnd.tmrk.ecloud.internetServicesList+xml") }

        describe "#body" do
          subject { @services.body }

          it { should have(3).items }

          context "[:InternetService]" do
            subject { @services.body[:InternetService] }

            it { should have(5).items }

            [0,1,2].each do |idx|
              let(:service) { subject[idx] }
              let(:mock_service) { @mock_vdc.internet_service_collection.items[idx] }
              let(:mock_ip) { mock_service._parent._parent }

              it_should_behave_like "an internet service without a backup internet service set"
            end

            context "for a service with a backup internet service" do
              let(:service) { subject[3] }
              let(:mock_service) { @mock_vdc.internet_service_collection.items[3] }
              let(:mock_ip) { mock_service._parent._parent }

              it_should_behave_like("an internet service with a backup internet service set")
            end

            context "for a backup internet service" do
              let(:service) { subject[4] }
              let(:mock_service) { @mock_vdc.internet_service_collection.backup_internet_services.first }

              it_should_behave_like("a backup internet service")
            end
          end
        end
      end

      context "with a valid Public IP uri" do
        before do
          @services = @vcloud.get_internet_services(@mock_service_collection.href)
        end
        subject { @services }

        it_should_behave_like("all responses")
        it { should have_headers_denoting_a_content_type_of("application/vnd.tmrk.ecloud.internetServicesList+xml") }

        describe "#body" do
          subject { @services.body }

          it { should have(3).items }

          context "[:InternetService]" do
            subject { @services.body[:InternetService] }

            it { should have(2).items }

            [0,1].each do |idx|
              let(:service) { subject[idx] }
              let(:mock_service) { @mock_service_collection.items[idx] }
              let(:mock_ip) { @mock_public_ip }

              it_should_behave_like("an internet service without a backup internet service set")
            end
          end
        end
      end

      context "with a public_ips_uri that doesn't exist" do
        subject { lambda { @vcloud.get_internet_services(URI.parse('https://www.fakey.c/piv8vc99')) } }

        it_should_behave_like("a request for a resource that doesn't exist")
      end
    end
  end
else
end
