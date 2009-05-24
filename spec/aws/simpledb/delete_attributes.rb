require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.delete_attributes' do

  before(:all) do
    sdb.create_domain('delete_attributes')
    sdb.put_attributes('delete_attributes', 'foo', { :bar => :baz })
  end

  after(:all) do
    sdb.delete_domain('delete_attributes')
  end

  it 'should have attributes for foo before delete_attributes' do
    lambda { sdb.get_attributes('delete_attributes', 'foo') }.should eventually { |expected| expected.body[:attributes].should == { 'bar' => ['baz'] } }
  end

  it 'should return proper attributes from delete_attributes' do
    actual = sdb.delete_attributes('delete_attributes', 'foo')
    actual.body[:request_id].should be_a(String)
    actual.body[:box_usage].should be_a(Float)
  end

  it 'should have no attributes for foo after delete_attributes' do
    lambda { sdb.get_attributes('delete_attributes', 'foo') }.should eventually { |expected| expected.body[:attributes].should be_empty }
  end

end
