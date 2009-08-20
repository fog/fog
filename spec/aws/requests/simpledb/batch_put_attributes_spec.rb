require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'SimpleDB.batch_put_attributes' do
  describe 'success' do

    before(:all) do
      @domain_name = "fog_domain_#{Time.now.to_i}"
      sdb.create_domain(@domain_name)
    end

    after(:all) do
      sdb.delete_domain(@domain_name)
    end

    it 'should return proper attributes' do
      actual = sdb.batch_put_attributes(@domain_name, { 'a' => { 'b' => 'c' }, 'x' => { 'y' => 'z' } })
      actual.body['RequestId'].should be_a(String)
      actual.body['BoxUsage'].should be_a(Float)
    end

  end
end