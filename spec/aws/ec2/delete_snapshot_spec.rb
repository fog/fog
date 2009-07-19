require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.delete_snapshot' do

  before(:all) do
    @volume_id = ec2.create_volume('us-east-1a', 1).body[:volume_id]
    @snapshot_id = ec2.create_snapshot(@volume_id).body[:snapshot_id]
  end

  after(:all) do
    ec2.delete_volume(@volume_id)
  end

  it "should return proper attributes" do
    eventually do
      actual = ec2.delete_snapshot(@snapshot_id)
      unless actual.body.empty?
        actual.body[:request_id].should be_a(String)
        [false, true].should include(actual.body[:return])
      end
    end
  end

end
