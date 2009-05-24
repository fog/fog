require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.get_attributes' do

  before(:all) do
    sdb.create_domain('get_attributes')
  end

  after(:all) do
    sdb.delete_domain('get_attributes')
  end

  it 'should have no attributes for foo before put_attributes' do
    lambda { sdb.get_attributes('get_attributes', 'foo') }.should eventually { |expected| expected.body[:attributes].should be_empty }
  end

  it 'should have attributes for foo after put_attributes' do
    sdb.put_attributes('get_attributes', 'foo', { :bar => :baz })
    lambda { sdb.get_attributes('get_attributes', 'foo') }.should eventually { |expected| expected.body[:attributes].should == { 'bar' => ['baz'] } }
  end

end
