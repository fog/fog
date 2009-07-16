require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_key_pairs' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_key_pairs
    actual.body[:key_set].should be_an(Array)
    actual.body[:request_id].should be_a(String)
    p actual
  end
  
  it "should return proper attributes with params"

end
