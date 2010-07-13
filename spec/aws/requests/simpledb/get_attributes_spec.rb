require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'SimpleDB.get_attributes' do
  describe 'success' do

    before(:each) do
      @domain_name = "fog_domain_#{Time.now.to_i}"
      AWS[:sdb].create_domain(@domain_name)
    end

    after(:each) do
      AWS[:sdb].delete_domain(@domain_name)
    end

    it 'should have no attributes for foo before put_attributes' do
      eventually do
        actual = AWS[:sdb].get_attributes(@domain_name, 'foo')
        actual.body['Attributes'].should be_empty
      end
    end

    it 'should return multi-value attributes from get_attributes' do
      AWS[:sdb].put_attributes(@domain_name, 'buzz', { "attr" => "foo" })
      AWS[:sdb].put_attributes(@domain_name, 'buzz', { "attr" => "foo2" })
      actual = AWS[:sdb].get_attributes(@domain_name, 'buzz')
      actual.body["Attributes"]["attr"].should == ['foo', 'foo2']
    end

    it 'should have attributes for foo after put_attributes' do
      AWS[:sdb].put_attributes(@domain_name, 'foo', { :bar => :baz })
      eventually do
        actual = AWS[:sdb].get_attributes(@domain_name, 'foo')
        actual.body['Attributes'].should == { 'bar' => ['baz'] }
      end
    end

  end
  describe 'failure' do

    it 'should raise a BadRequest error if the domain does not exist' do
      lambda {
        AWS[:sdb].get_attributes('notadomain', 'notanattribute')
      }.should raise_error(Excon::Errors::BadRequest)
    end

    it 'should not raise an error if the attribute does not exist' do
      @domain_name = "fog_domain_#{Time.now.to_i}"
      AWS[:sdb].create_domain(@domain_name)
      AWS[:sdb].get_attributes(@domain_name, 'notanattribute')
      AWS[:sdb].delete_domain(@domain_name)
    end

  end
end
