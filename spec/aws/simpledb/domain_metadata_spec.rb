require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.domain_metadata' do

  before(:all) do
    sdb.create_domain('domain_metadata')
  end

  after(:all) do
    sdb.delete_domain('domain_metadata')
  end

  it 'should return proper attributes when there are no items' do
    results = sdb.domain_metadata('domain_metadata')
    results[:attribute_name_count].should == 0
    results[:attribute_names_size_bytes].should == 0
    results[:attribute_value_count].should == 0
    results[:attribute_values_size_bytes].should == 0
    results[:box_usage].should be_a(Float)
    results[:item_count].should == 0
    results[:item_names_size_bytes].should == 0
    results[:request_id].should be_a(String)
    results[:timestamp].should be_a(String)
  end

  it 'should return proper attributes with items' do
    sdb.put_attributes('domain_metadata', 'foo', { :bar => :baz })
    results = sdb.domain_metadata('domain_metadata')
    results[:attribute_name_count].should == 1
    results[:attribute_names_size_bytes].should == 3
    results[:attribute_value_count].should == 1
    results[:attribute_values_size_bytes].should == 3
    results[:box_usage].should be_a(Float)
    results[:item_count].should == 1
    results[:item_names_size_bytes].should == 3
    results[:request_id].should be_a(String)
    results[:timestamp].should be_a(String)
  end

end
