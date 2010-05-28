require File.join(File.dirname(__FILE__),'..','..','..','spec_helper')

describe "Fog::Vcloud::Terremark::Ecloud::PublicIp", :type => :tmrk_ecloud_model do
  before do
    @mock_ip = @mock_vdc[:public_ips].first
    @mock_ip_uri = URI.parse("#{@base_url}/extensions/publicIp/#{@mock_ip[:id]}")
  end

  subject { @vcloud }

  it { should respond_to :get_public_ip }

  describe :class do
    subject { Fog::Vcloud::Terremark::Ecloud::PublicIp }

    it { should have_identity :href }
    it { should have_only_these_attributes [:name, :type, :id, :href] }
  end

  context "with no uri" do

    subject { Fog::Vcloud::Terremark::Ecloud::PublicIp.new() }

    its(:href)     { should be_nil }
    its(:identity) { should be_nil }
    its(:name)     { should be_nil }
    its(:type)     { should be_nil }
  end

  context "as a collection member" do
    subject { @vcloud.vdcs[0].public_ips[0] }

    it { should be_an_instance_of Fog::Vcloud::Terremark::Ecloud::PublicIp }

    its(:href)                  { should == @mock_ip_uri }
    its(:identity)              { should == @mock_ip_uri }
    its(:name)                  { should == @mock_ip[:name] }
    its(:id)                    { should == @mock_ip[:id] }

    its(:internet_services)     { should have(2).services }
 
  end
end
