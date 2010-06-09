require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

describe "Fog::Vcloud::Terremark::Ecloud::Ips", :type => :tmrk_ecloud_model do
  subject { @vcloud }

  it { should_not respond_to :ips }

  describe :class do
    subject { @vcloud.vdcs[0].networks[0].ips.class }
    its(:model)       { should == Fog::Vcloud::Terremark::Ecloud::Ip }
    its(:get_request) { should be_nil }
    its(:all_request) { should be_nil }
    its(:vcloud_type) { should be_nil }
    it { should_not respond_to :create }
  end

  describe :ips do
    subject { @vcloud.vdcs[0].networks[0].ips }

    it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::Ips }

    its(:length) { should == 252 }

    it { should have_members_of_the_right_model }
  end
end


