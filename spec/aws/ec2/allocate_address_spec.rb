require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.batch_put_attributes' do

  it "should return proper attributes" do
    actual = ec2.allocate_address
    actual.body[:public_ip].should be_a(String)
    p actual
  end

end
