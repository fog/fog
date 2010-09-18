require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.put_object' do
  describe 'success' do

    before(:each) do
      Google[:storage].put_bucket('fogputobject')
      @response = Google[:storage].put_object('fogputobject', 'fog_put_object', lorem_file)
    end

    after(:each) do
      Google[:storage].delete_object('fogputobject', 'fog_put_object')
      Google[:storage].delete_bucket('fogputobject')
    end

    it 'should return proper attributes' do
      @response.status.should == 200
    end

    it 'should not raise an error if the object already exists' do
      actual = Google[:storage].put_object('fogputobject', 'fog_put_object', lorem_file)
      actual.status.should == 200
    end

  end
  describe 'failure' do

    it 'should raise a NotFound error if the bucket does not exist' do
      lambda {
        Google[:storage].put_object('fognotabucket', 'fog_put_object', lorem_file)
      }.should raise_error(Excon::Errors::NotFound)
    end

    it 'should not raise an error if the object already exists' do
      Google[:storage].put_bucket('fogputobject')
      Google[:storage].put_object('fogputobject', 'fog_put_object', lorem_file)
      Google[:storage].put_object('fogputobject', 'fog_put_object', lorem_file)
      Google[:storage].delete_object('fogputobject', 'fog_put_object')
      Google[:storage].delete_bucket('fogputobject')
    end

  end
end
