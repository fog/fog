require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.put_attributes' do

  before(:all) do
    sdb.create_domain('put_attributes')
  end

  after(:all) do
    sdb.delete_domain('put_attributes')
  end

  it 'should have no attributes for foo before put_attributes' do
    lambda { sdb.get_attributes('put_attributes', 'foo') }.should eventually { |expected| expected.body[:attributes].should be_empty }
  end

  it 'should return proper attributes from put_attributes' do
    actual = sdb.put_attributes('put_attributes', 'foo', { 'bar' => 'baz' })
    actual.body[:request_id].should be_a(String)
    actual.body[:box_usage].should be_a(Float)
  end

  it 'should have attributes for foo after put_attributes' do
    lambda { sdb.get_attributes('put_attributes', 'foo') }.should eventually { |expected| expected.body[:attributes].should == { 'bar' => ['baz'] } }
  end

end
