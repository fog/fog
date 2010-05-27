require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

describe "Fog::Vcloud::Terremark::Ecloud::PublicIps", :type => :tmrk_ecloud_model do
  subject { @vcloud }

  it { should respond_to :public_ips }

  describe :class do
    subject { @vcloud.public_ips.class }
    its(:model)       { should == Fog::Vcloud::Terremark::Ecloud::PublicIp }
    its(:get_request) { should == :get_public_ip }
    its(:all_request) { should be_an_instance_of Proc }
    its(:vcloud_type) { should == "application/vnd.tmrk.ecloud.publicIp+xml" }
  end

  describe :public_ips do
    subject { @vcloud.vdcs[0].public_ips }

    it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::PublicIps }

    its(:length) { should == 3 }

    it { should have_members_of_the_right_model }
  end
end

