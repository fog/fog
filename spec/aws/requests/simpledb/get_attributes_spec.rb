require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'SimpleDB.get_attributes' do

  before(:all) do
    @sdb = Fog::AWS::SimpleDB.gen
    @domain_name = "fog_domain_#{Time.now.to_i}"
    @sdb.create_domain(@domain_name)
  end

  after(:all) do
    @sdb.delete_domain(@domain_name)
  end

  it 'should have no attributes for foo before put_attributes' do
    eventually do
      actual = @sdb.get_attributes(@domain_name, 'foo')
      actual.body['Attributes'].should be_empty
    end
  end

  it 'should have attributes for foo after put_attributes' do
    @sdb.put_attributes(@domain_name, 'foo', { :bar => :baz })
    eventually do
      actual = @sdb.get_attributes(@domain_name, 'foo')
      actual.body['Attributes'].should == { 'bar' => ['baz'] }
    end
  end

end
