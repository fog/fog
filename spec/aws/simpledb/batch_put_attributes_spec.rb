require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.batch_put_attributes' do

  before(:all) do
    sdb.create_domain('batch_put_attributes')
  end

  after(:all) do
    sdb.delete_domain('batch_put_attributes')
  end

  it 'should have no attributes for y before batch_put_attributes' do
    lambda { sdb.get_attributes('batch_put_attributes', 'a') }.should eventually { |expected| expected[:attributes].should be_empty }
  end

  it 'should have no attributes for x before batch_put_attributes' do
    lambda { sdb.get_attributes('batch_put_attributes', 'x') }.should eventually { |expected| expected[:attributes].should be_empty }
  end

  it 'should return proper attributes from batch_put_attributes' do
    actual = sdb.batch_put_attributes('batch_put_attributes', { 'a' => { 'b' => 'c' }, 'x' => { 'y' => 'z' } })
    actual[:request_id].should be_a(String)
    actual[:box_usage].should be_a(Float)
  end

  it 'should have correct attributes for a after batch_put_attributes' do
    lambda { sdb.get_attributes('batch_put_attributes', 'a') }.should eventually { |expected| expected[:attributes].should == { 'b' => ['c'] } }
  end

  it 'should have correct attributes for x after batch_put_attributes' do
    lambda { sdb.get_attributes('batch_put_attributes', 'x') }.should eventually { |expected| expected[:attributes].should == { 'y' => ['z'] } }
  end

end