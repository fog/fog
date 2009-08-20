require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'SimpleDB.delete_attributes' do
  describe 'success' do

    before(:each) do
      sdb.create_domain('delete_attributes')
      sdb.put_attributes('delete_attributes', 'foo', { :bar => :baz })
    end

    after(:each) do
      sdb.delete_domain('delete_attributes')
    end

    it 'should return proper attributes from delete_attributes' do
      actual = sdb.delete_attributes('delete_attributes', 'foo')
      actual.body['RequestId'].should be_a(String)
      actual.body['BoxUsage'].should be_a(Float)
    end

  end
end
