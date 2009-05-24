require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.list_domains' do

  before(:all) do
    sdb.create_domain('list_domains')
  end

  after(:all) do
    sdb.delete_domain('list_domains')
  end

  it 'should return proper attributes' do
    results = sdb.list_domains
    results.body[:box_usage].should be_a(Float)
    results.body[:domains].should be_an(Array)
    results.body[:request_id].should be_a(String)
  end

  it 'should include list_domains in list_domains' do
    lambda { sdb.list_domains }.should eventually { |expected| expected.body[:domains].should include('list_domains') }
  end

end
