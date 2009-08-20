require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.create_security_group' do
  describe 'success' do

    after(:all) do
      ec2.delete_security_group('fog_security_group')
    end

    it "should return proper attributes" do
      actual = ec2.create_security_group('fog_security_group', 'a security group for testing fog')
      actual.body['requestId'].should be_a(String)
      [false, true].should include(actual.body['return'])
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error when the security group already exists" do
      lambda {
        ec2.create_security_group('fog_security_group', 'a security group for testing fog')
      }.should raise_error(Fog::Errors::BadRequest)
    end

  end
end
