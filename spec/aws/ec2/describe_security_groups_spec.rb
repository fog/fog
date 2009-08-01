require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_security_groups' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_security_groups
    actual.body['requestId'].should be_a(String)
    actual.body['securityGroupInfo'].should be_an(Array)
    security_group = actual.body['securityGroupInfo'].select do |security_group| 
      security_group['groupName'] == 'default'
    end.first
    security_group['groupDescription'].should be_a(String)
    security_group['groupName'].should be_a(String)
    security_group['ownerId'].should be_a(String)
    security_group['ipPermissions'].should be_an(Array)
    ip_permission = security_group['ipPermissions'].first
    ip_permission['groups'].should be_an(Array)
    group = ip_permission['groups'].first
    group['groupName'].should be_a(String)
    group['userId'].should be_a(String)
    ip_permission['fromPort'].should be_an(Integer)
    ip_permission['ipProtocol'].should be_a(String)
    ip_permission['ipRanges'].should be_an(Array)
    ip_permission['toPort'].should be_an(Integer)
  end

  it "should return proper attributes with params" do
    actual = ec2.describe_security_groups('default')
    actual.body['requestId'].should be_a(String)
    actual.body['securityGroupInfo'].should be_an(Array)
    security_group = actual.body['securityGroupInfo'].select do |security_group| 
      security_group['groupName'] == 'default'
    end.first
    security_group['groupDescription'].should be_a(String)
    security_group['groupName'].should be_a(String)
    security_group['ownerId'].should be_a(String)
    security_group['ipPermissions'].should be_an(Array)
    ip_permission = security_group['ipPermissions'].first
    ip_permission['groups'].should be_an(Array)
    group = ip_permission['groups'].first
    group['groupName'].should be_a(String)
    group['userId'].should be_a(String)
    ip_permission['fromPort'].should be_an(Integer)
    ip_permission['ipProtocol'].should be_a(String)
    ip_permission['ipRanges'].should be_an(Array)
    ip_permission['toPort'].should be_an(Integer)
  end

end
