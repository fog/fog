require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.revoke_security_group_ingress' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
    @ec2.create_security_group('fog_security_group', 'a security group for testing fog')
    @ec2.authorize_security_group_ingress({
      'FromPort' => 80,
      'GroupName' => 'fog_security_group',
      'IpProtocol' => 'tcp',
      'ToPort' => 80
    })
  end

  after(:all) do
    @ec2.delete_security_group('fog_security_group')
  end

  it "should return proper attributes" do
    actual = @ec2.revoke_security_group_ingress({
      'FromPort' => 80,
      'GroupName' => 'fog_security_group',
      'IpProtocol' => 'tcp',
      'ToPort' => 80
    })
    actual.body['requestId'].should be_a(String)
    [false, true].should include(actual.body['return'])
  end

end
