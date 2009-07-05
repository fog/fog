require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.create_security_group' do

  after(:all) do
    ec2.delete_security_group('fog_security_group')
  end

  it "should return proper attributes" do
    actual = ec2.create_security_group('fog_security_group', 'a security group for testing fog')
    actual.body[:request_id].should be_a(String)
    [false, true].should include(actual.body[:return])
  end

end
