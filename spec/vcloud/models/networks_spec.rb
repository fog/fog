require 'vcloud/spec_helper'

if Fog.mocking?
  describe "Fog::Vcloud::Compute::Networks", :type => :mock_vcloud_model do
    subject { @vcloud }

    it { should respond_to(:networks) }

    describe :class do
      subject { @vcloud.networks.class }
      its(:model)       { should == Fog::Vcloud::Compute::Network }
    end

    describe :networks do
      subject { @vcloud.vdcs[0].networks }
      it { should_not respond_to(:create) }

      it { should be_an_instance_of(Fog::Vcloud::Compute::Networks) }

      its(:length) { should == 2 }

      it { should have_members_of_the_right_model }
    end
  end
else
end

