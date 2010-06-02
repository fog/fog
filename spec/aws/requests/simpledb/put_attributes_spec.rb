require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'SimpleDB.put_attributes' do
  describe 'success' do

    before(:each) do
      @domain_name = "fog_domain_#{Time.now.to_i}"
      AWS[:sdb].create_domain(@domain_name)
    end

    after(:each) do
      AWS[:sdb].delete_domain(@domain_name)
    end

    it 'should return proper attributes from put_attributes' do
      actual = AWS[:sdb].put_attributes(@domain_name, 'foo', { 'bar' => 'baz' })
      actual.body['RequestId'].should be_a(String)
      actual.body['BoxUsage'].should be_a(Float)
    end

    it 'conditional put should succeed' do
      actual = AWS[:sdb].put_conditional(@domain_name, 'foo', { 'version' => '1' }, { 'version' => nil })
      actual = AWS[:sdb].put_conditional(@domain_name, 'foo', { 'version' => '2' }, { 'version' => '1' })
      actual.body['RequestId'].should be_a(String)
      actual.body['BoxUsage'].should be_a(Float)
    end

    it 'conditional put should raise Conflict error' do
      actual = AWS[:sdb].put_conditional(@domain_name, 'foo', { 'version' => '2' })
      actual.body['RequestId'].should be_a(String)
      actual.body['BoxUsage'].should be_a(Float)

      lambda {
        actual = AWS[:sdb].put_conditional(@domain_name, 'foo', { 'version' => '2' }, { 'version' => '1' })
      }.should raise_error(Excon::Errors::Conflict)
    end

  end
  describe 'failure' do

    it 'should raise a BadRequest error if the domain does not exist' do
      lambda {
        AWS[:sdb].put_attributes(@domain_name, 'notadomain', { 'notanattribute' => 'value' })
      }.should raise_error(Excon::Errors::BadRequest)
    end

  end
end
