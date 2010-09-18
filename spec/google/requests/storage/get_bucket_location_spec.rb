require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.get_bucket_location' do
  describe 'success' do

    before(:each) do
      Google[:storage].put_bucket('foggetlocation', 'LocationConstraint' => 'EU')
    end

    after(:each) do
      Google[:eu_storage].delete_bucket('foggetlocation')
    end

    it 'should return proper attributes' do
      actual = Google[:storage].get_bucket_location('foggetlocation')
      actual.status.should == 200
      actual.body['LocationConstraint'].should == 'EU'
    end

  end
  describe 'failure' do

    it 'should raise NotFound error if bucket does not exist' do
      lambda {
        Google[:storage].get_bucket_location('fognotabucket')
      }.should raise_error(Excon::Errors::NotFound)
    end

  end
end
