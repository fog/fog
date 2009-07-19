require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_security_groups' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_security_groups
    actual.body[:request_id].should be_a(String)
    actual.body[:security_group_info].should be_an(Array)
    security_group = actual.body[:security_group_info].select do |security_group| 
      security_group[:group_name] == 'default'
    end.first
    security_group[:group_description].should be_a(String)
    security_group[:group_name].should be_a(String)
    security_group[:owner_id].should be_a(String)
    security_group[:ip_permissions].should be_an(Array)
    ip_permission = security_group[:ip_permissions].first
    ip_permission[:groups].should be_an(Array)
    group = ip_permission[:groups].first
    group[:user_id].should be_a(String)
    group[:group_name].should be_a(String)
    ip_permission[:from_port].should be_an(Integer)
    ip_permission[:ip_protocol].should be_a(String)
    ip_permission[:ip_ranges].should be_an(Array)
    ip_permission[:to_port].should be_an(Integer)
  end
  
  it "should return proper attributes with params" do
    actual = ec2.describe_security_groups('default')
    actual.body[:request_id].should be_a(String)
    actual.body[:security_group_info].should be_an(Array)
    security_group = actual.body[:security_group_info].select do |security_group| 
      security_group[:group_name] == 'default'
    end.first
    security_group[:group_description].should be_a(String)
    security_group[:group_name].should be_a(String)
    security_group[:owner_id].should be_a(String)
    security_group[:ip_permissions].should be_an(Array)
    ip_permission = security_group[:ip_permissions].first
    ip_permission[:groups].should be_an(Array)
    group = ip_permission[:groups].first
    group[:user_id].should be_a(String)
    group[:group_name].should be_a(String)
    ip_permission[:from_port].should be_an(Integer)
    ip_permission[:ip_protocol].should be_a(String)
    ip_permission[:ip_ranges].should be_an(Array)
    ip_permission[:to_port].should be_an(Integer)
  end

end
