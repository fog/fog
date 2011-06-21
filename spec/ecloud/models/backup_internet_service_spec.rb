require 'ecloud/spec_helper'

if Fog.mocking?
  describe "Fog::Compute::Ecloud::BackupInternetService", :type => :mock_tmrk_ecloud_model do
    subject { @vcloud.vdcs[0].backup_internet_services[0] }

    describe :class do
      subject { Fog::Compute::Ecloud::BackupInternetService }

      it { should have_identity(:href) }
      it { should have_only_these_attributes([:href, :name, :id, :protocol, :enabled, :description, :timeout, :redirect_url, :monitor]) }
    end

    context "with no uri" do

      subject { Fog::Compute::Ecloud::BackupInternetService.new() }
      it { should have_all_attributes_be_nil }

    end

    context "as a collection member" do
      subject { @vcloud.vdcs[0].backup_internet_services[0].reload }

      let(:composed_service_data) { @vcloud.vdcs[0].backup_internet_services[0].send(:_compose_service_data) }

      it { should be_an_instance_of(Fog::Compute::Ecloud::BackupInternetService) }

      its(:href)                  { should == @mock_backup_service.href }
      its(:identity)              { should == @mock_backup_service.href }
      its(:name)                  { should == @mock_backup_service.name }
      its(:id)                    { should == @mock_backup_service.object_id.to_s }
      its(:protocol)              { should == @mock_backup_service.protocol }
      its(:enabled)               { should == @mock_backup_service.enabled.to_s }
      its(:description)           { should == @mock_backup_service.description }
      its(:timeout)               { should == @mock_backup_service.timeout.to_s }
      its(:redirect_url)          { should == (@mock_backup_service.redirect_url || "") }
      its(:monitor)               { should == nil }

      specify { composed_service_data[:href].should == subject.href.to_s }
      specify { composed_service_data[:name].should == subject.name }
      specify { composed_service_data[:id].should == subject.id.to_s }
      specify { composed_service_data[:protocol].should == subject.protocol }
      specify { composed_service_data[:enabled].should == subject.enabled.to_s }
      specify { composed_service_data[:description].should == subject.description }
      specify { composed_service_data[:timeout].should == subject.timeout.to_s }
    end
  end
end
