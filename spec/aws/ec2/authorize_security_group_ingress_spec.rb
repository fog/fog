require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.authorize_security_group_ingress' do

  before(:all) do
    ec2.create_security_group('fog_security_group', 'a security group for testing fog')
  end

  after(:all) do
    ec2.delete_security_group('fog_security_group')
  end

  it "should return proper attributes" do
    actual = ec2.authorize_security_group_ingress({
      :cidr_id => '127.0.0.1',
      :from_port => 80,
      :group_name => 'fog_security_group',
      :ip_protocol => 'tcp',
      :to_port => 80,
    })
    actual.body[:request_id].should be_a(String)
    [false, true].should include(actual.body[:return])
  end

end
