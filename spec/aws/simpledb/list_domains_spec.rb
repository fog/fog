require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.list_domains' do

  before(:all) do
    @domain_name = "fog_domain_#{Time.now.to_i}"
  end

  after(:all) do
    sdb.delete_domain(@domain_name)
  end

  it 'should return proper attributes' do
    results = sdb.list_domains
    results.body[:box_usage].should be_a(Float)
    results.body[:domains].should be_an(Array)
    results.body[:request_id].should be_a(String)
  end

  it 'should include created domains' do
    sdb.create_domain(@domain_name)
    eventually do
      actual = sdb.list_domains
      actual.body[:domains].should include(@domain_name)
    end
  end

end
