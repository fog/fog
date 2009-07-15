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
    results.body[:attribute_name_count].should == 0
    results.body[:attribute_names_size_bytes].should == 0
    results.body[:attribute_value_count].should == 0
    results.body[:attribute_values_size_bytes].should == 0
    results.body[:box_usage].should be_a(Float)
    results.body[:item_count].should == 0
    results.body[:item_names_size_bytes].should == 0
    results.body[:request_id].should be_a(String)
    results.body[:timestamp].should be_a(Time)
  end

  it 'should return proper attributes with items' do
    sdb.put_attributes(@domain_name, 'foo', { :bar => :baz })
    results = sdb.domain_metadata(@domain_name)
    results.body[:attribute_name_count].should == 1
    results.body[:attribute_names_size_bytes].should == 3
    results.body[:attribute_value_count].should == 1
    results.body[:attribute_values_size_bytes].should == 3
    results.body[:box_usage].should be_a(Float)
    results.body[:item_count].should == 1
    results.body[:item_names_size_bytes].should == 3
    results.body[:request_id].should be_a(String)
    results.body[:timestamp].should be_a(Time)
  end

end
