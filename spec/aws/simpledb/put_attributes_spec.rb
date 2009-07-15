require File.dirname(__FILE__) + '/../../spec_helper'

describe 'SimpleDB.put_attributes' do

  before(:all) do
    @domain_name = "fog_domain_#{Time.now.to_i}"
    sdb.create_domain(@domain_name)
  end

  after(:all) do
    sdb.delete_domain(@domain_name)
  end

  it 'should return proper attributes from put_attributes' do
    actual = sdb.put_attributes(@domain_name, 'foo', { 'bar' => 'baz' })
    actual.body[:request_id].should be_a(String)
    actual.body[:box_usage].should be_a(Float)
  end

end
