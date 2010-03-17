require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.authorize_security_group_ingress' do
  describe 'success' do

    before(:each) do
      AWS[:ec2].create_security_group('fog_security_group', 'a security group for testing fog')
    end

    after(:each) do
      AWS[:ec2].delete_security_group('fog_security_group')
    end

    it "should return proper attributes for port based ingress" do
      actual = AWS[:ec2].authorize_security_group_ingress({
        'FromPort' => 80,
        'GroupName' => 'fog_security_group',
        'IpProtocol' => 'tcp',
        'ToPort' => 80,
      })
      actual.body['requestId'].should be_a(String)
      [false, true].should include(actual.body['return'])
    end

    it "should return proper attributes for named ingress" do
      actual = AWS[:ec2].authorize_security_group_ingress({
        'GroupName'                   => 'fog_security_group',
        'SourceSecurityGroupName'     => 'fog_security_group',
        'SourceSecurityGroupOwnerId'  => '254056571511'
      })
      actual.body['requestId'].should be_a(String)
      [false, true].should include(actual.body['return'])
    end

  end
end
