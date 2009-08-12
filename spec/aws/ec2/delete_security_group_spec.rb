require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.delete_security_group' do

  before(:all) do
    @ec2 = Fog::AWS::EC2.gen
    @ec2.create_security_group('fog_security_group', 'a security group for testing fog')
  end

  it "should return proper attributes" do
    actual = @ec2.delete_security_group('fog_security_group')
    actual.body['requestId'].should be_a(String)
    [false, true].should include(actual.body['return'])
  end

end
