require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.delete_domain' do

  before(:all) do
    sdb.create_domain('delete_domain')
  end

  it 'should include delete_domain in list_domains before delete_domain' do
    lambda { sdb.list_domains }.should eventually { |expected| expected.body[:domains].should include('delete_domain') }
  end

  it 'should return proper attributes' do
    actual = sdb.delete_domain('delete_domain')
    actual.body[:request_id].should be_a(String)
    actual.body[:box_usage].should be_a(Float)
  end

  it 'should not include delete_domain in list_domains after delete_domain' do
    lambda { sdb.list_domains }.should_not eventually { |expected| expected.body[:domains].should_not include('delete_domain') }
  end

end