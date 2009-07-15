require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.create_domain' do

  before(:all) do
    @domain_name = "fog_domain_#{Time.now.to_i}"
  end

  after(:all) do
    sdb.delete_domain(@domain_name)
  end

  it 'should return proper attributes' do
    actual = sdb.create_domain(@domain_name)
    actual.body[:request_id].should be_a(String)
    actual.body[:box_usage].should be_a(Float)
  end

end
