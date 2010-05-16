require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

describe "Fog::Vcloud::Terremark::Ecloud::Vdcs", :type => :tmrk_ecloud_model do
  subject { @vcloud }

  it { should respond_to :vdcs }

  describe :class do
    subject { @vcloud.vdcs.class }
    its(:model)       { should == Fog::Vcloud::Terremark::Ecloud::Vdc }
    its(:get_request) { should == :get_vdc }
    its(:all_request) { should be_an_instance_of Proc }
    its(:vcloud_type) { should == "application/vnd.vmware.vcloud.vdc+xml" }
  end

  describe :vdcs do
    subject { @vcloud.vdcs }

    it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::Vdcs }

    its(:length) { should == 2 }

    it { should have_members_of_the_right_model }
  end
end
