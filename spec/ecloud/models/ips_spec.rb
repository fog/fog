require 'ecloud/spec_helper'

if Fog.mocking?
  describe "Fog::Compute::Ecloud::Ips", :type => :mock_tmrk_ecloud_model do
    subject { @vcloud }

    it { should respond_to(:ips) }

    describe :class do
      subject { @vcloud.vdcs[0].networks[0].ips.class }
      its(:model)       { should == Fog::Compute::Ecloud::Ip }
    end

    describe :ips do
      subject { @vcloud.vdcs[0].networks[0].ips.reload }
      it { should_not respond_to(:create) }

      it { should be_an_instance_of(Fog::Compute::Ecloud::Ips) }

      its(:length) { should == 252 }

      it { should have_members_of_the_right_model }
    end
  end
else
end


