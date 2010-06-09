require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

describe "Fog::Vcloud::Terremark::Ecloud::Networks", :type => :tmrk_ecloud_model do
  subject { @vcloud }

  it { should respond_to :networks }

  describe :class do
    subject { @vcloud.networks.class }
    its(:model)       { should == Fog::Vcloud::Terremark::Ecloud::Network }
    its(:get_request) { should == :get_network }
    its(:all_request) { should be_an_instance_of Proc }
    its(:vcloud_type) { should == "application/vnd.vmware.vcloud.network+xml" }
  end

  describe :networks do
    subject { @vcloud.vdcs[0].networks }

    it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::Networks }

    its(:length) { should == 2 }

    it { should have_members_of_the_right_model }
  end
end

