require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.run_instances' do

  it "should return proper attributes" do
    actual = ec2.run_instances('ami-5ee70037', 1, 1)
    p actual
  end

end
