require 'ecloud/spec_helper'

if Fog.mocking?
  describe "Fog::Ecloud::Compute::Vdcs", :type => :mock_tmrk_ecloud_model do
    subject { @vcloud }

    it { should respond_to(:vdcs) }

    describe :class do
      subject { @vcloud.vdcs.class }
      its(:model)       { should == Fog::Ecloud::Compute::Vdc }
    end

    describe :vdcs do
      subject { @vcloud.vdcs }
      it { should_not respond_to(:create) }

      it { should be_an_instance_of(Fog::Ecloud::Compute::Vdcs) }

      its(:length) { should == 2 }

      it { should have_members_of_the_right_model }

      its(:organization_uri) { should == @mock_organization.href }
    end
  end
else
end
