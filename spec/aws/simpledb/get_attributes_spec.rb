require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.get_attributes' do

  before(:all) do
    @domain_name = "fog_domain_#{Time.now.to_i}"
    sdb.create_domain(@domain_name)
  end

  after(:all) do
    sdb.delete_domain(@domain_name)
  end

  it 'should have no attributes for foo before put_attributes' do
    lambda { sdb.get_attributes(@domain_name, 'foo') }.should eventually { |expected| expected.body[:attributes].should be_empty }
  end

  it 'should have attributes for foo after put_attributes' do
    sdb.put_attributes(@domain_name, 'foo', { :bar => :baz })
    lambda { sdb.get_attributes(@domain_name, 'foo') }.should eventually { |expected| expected.body[:attributes].should == { 'bar' => ['baz'] } }
  end

end
