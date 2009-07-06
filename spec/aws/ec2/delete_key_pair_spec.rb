require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.delete_key_pair' do

  before(:all) do
    ec2.create_key_pair('fog_key_pair')
  end

  it "should return proper attributes" do
    actual = ec2.delete_key_pair('fog_key_pair')
    actual.body[:request_id].should be_a(String)
    [false, true].should include(actual.body[:return])
  end

end
