require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.delete_snapshot' do
  describe 'success' do

    before(:each) do
      @volume_id = ec2.create_volume('us-east-1a', 1).body['volumeId']
      @snapshot_id = ec2.create_snapshot(@volume_id).body['snapshotId']
    end

    after(:each) do
      ec2.delete_volume(@volume_id)
    end

    it "should return proper attributes" do
      eventually do
        actual = ec2.delete_snapshot(@snapshot_id)
        unless actual.body.empty?
          actual.body['requestId'].should be_a(String)
          [false, true].should include(actual.body['return'])
        end
      end
    end

  end
  describe 'failure' do

    it "should raise a BadRequest error if snapshot does not exist" do
      lambda {
        ec2.release_address('snap-00000000')
      }.should raise_error(Excon::Errors::BadRequest)
    end

  end
end
