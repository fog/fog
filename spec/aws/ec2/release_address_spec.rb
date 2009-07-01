require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.release' do

  before(:all) do
    @public_ip = ec2.allocate_address
  end

  it "should return proper attributes" do
    actual = ec2.release_address(@public_ip.body[:public_ip])
    actual.body[:return].should == true
    p actual
  end

end
