require 'ecloud/spec_helper'

if Fog.mocking?
  describe "Fog::Ecloud::Compute::Networks", :type => :mock_tmrk_ecloud_model do
    subject { @vcloud }

    it { should respond_to(:networks) }

    describe :class do
      subject { @vcloud.networks.class }
      its(:model)       { should == Fog::Ecloud::Compute::Network }
    end

    describe :networks do
      subject { @vcloud.vdcs[0].networks }
      it { should_not respond_to(:create) }

      it { should be_an_instance_of(Fog::Ecloud::Compute::Networks) }

      its(:length) { should == 2 }

      it { should have_members_of_the_right_model }
    end
  end
else
end

