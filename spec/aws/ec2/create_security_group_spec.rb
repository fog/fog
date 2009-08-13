require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.create_security_group' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
  end

  after(:all) do
    @ec2.delete_security_group('fog_security_group')
  end

  it "should return proper attributes" do
    actual = @ec2.create_security_group('fog_security_group', 'a security group for testing fog')
    actual.body['requestId'].should be_a(String)
    [false, true].should include(actual.body['return'])
  end

end
