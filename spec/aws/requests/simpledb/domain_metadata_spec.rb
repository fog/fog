require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.domain_metadata' do

  before(:all) do
    @domain_name = "fog_domain_#{Time.now.to_i}"
    sdb.create_domain(@domain_name)
  end

  after(:all) do
    sdb.delete_domain(@domain_name)
  end

  it 'should return proper attributes when there are no items' do
    results = sdb.domain_metadata(@domain_name)
    results.body['AttributeNameCount'].should == 0
    results.body['AttributeNamesSizeBytes'].should == 0
    results.body['AttributeValueCount'].should == 0
    results.body['AttributeValuesSizeBytes'].should == 0
    results.body['BoxUsage'].should be_a(Float)
    results.body['ItemCount'].should == 0
    results.body['ItemNamesSizeBytes'].should == 0
    results.body['RequestId'].should be_a(String)
    results.body['Timestamp'].should be_a(Time)
  end

  it 'should return proper attributes with items' do
    sdb.put_attributes(@domain_name, 'foo', { :bar => :baz })
    results = sdb.domain_metadata(@domain_name)
    results.body['AttributeNameCount'].should == 1
    results.body['AttributeNamesSizeBytes'].should == 3
    results.body['AttributeValueCount'].should == 1
    results.body['AttributeValuesSizeBytes'].should == 3
    results.body['BoxUsage'].should be_a(Float)
    results.body['ItemCount'].should == 1
    results.body['ItemNamesSizeBytes'].should == 3
    results.body['RequestId'].should be_a(String)
    results.body['Timestamp'].should be_a(Time)
  end

end
