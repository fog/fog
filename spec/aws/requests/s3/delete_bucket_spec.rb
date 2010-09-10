require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.delete_bucket' do
  describe 'success' do

    before(:each) do
      AWS[:storage].put_bucket('fogdeletebucket')
    end

    it 'should return proper attributes' do
      actual = AWS[:storage].delete_bucket('fogdeletebucket')
      actual.status.should == 204
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        AWS[:storage].delete_bucket('fognotabucket')
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should raise a Conflict error if the bucket is not empty' do
      AWS[:storage].put_bucket('fogdeletebucket')
      AWS[:storage].put_object('fogdeletebucket', 'fog_delete_object', lorem_file)
      lambda {
        AWS[:storage].delete_bucket('fogdeletebucket')
      }.should raise_error(Excon::Errors::Conflict)
      AWS[:storage].delete_object('fogdeletebucket', 'fog_delete_object')
      AWS[:storage].delete_bucket('fogdeletebucket')
    end

  end
end
