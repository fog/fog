require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.delete_bucket' do
  describe 'success' do

    before(:each) do
      Google[:storage].put_bucket('fogdeletebucket')
    end

    it 'should return proper attributes' do
      actual = Google[:storage].delete_bucket('fogdeletebucket')
      actual.status.should == 204
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        Google[:storage].delete_bucket('fognotabucket')
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should raise a Conflict error if the bucket is not empty' do
      Google[:storage].put_bucket('fogdeletebucket')
      Google[:storage].put_object('fogdeletebucket', 'fog_delete_object', lorem_file)
      lambda {
        Google[:storage].delete_bucket('fogdeletebucket')
      }.should raise_error(Excon::Errors::Conflict)
      Google[:storage].delete_object('fogdeletebucket', 'fog_delete_object')
      Google[:storage].delete_bucket('fogdeletebucket')
    end

  end
end
