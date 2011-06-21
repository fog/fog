require 'ecloud/spec_helper'

if Fog.mocking?
  describe "Fog::Compute::Ecloud::InternetServices", :type => :mock_tmrk_ecloud_model do
    context "as an attribute of a VDC" do
      subject { @vcloud.vdcs[0] }

      it { should respond_to(:backup_internet_services) }

      describe :class do
        subject { @vcloud.vdcs[0].backup_internet_services.class }
        its(:model)       { should == Fog::Compute::Ecloud::BackupInternetService }
      end

      describe :backup_internet_services do
        subject { @vcloud.vdcs[0].backup_internet_services }

        it { should respond_to(:create) }

        it { should be_an_instance_of(Fog::Compute::Ecloud::BackupInternetServices) }

        its(:length) { should == 1 }

        it { should(have_members_of_the_right_model) }
      end
    end
  end
end
