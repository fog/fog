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
      Fog.wait_for do
        actual = AWS[:sdb].get_attributes(@domain_name, 'foo')
        actual.body['Attributes'].empty?
      end
    end

    it 'should return multi-value attributes from get_attributes' do
      AWS[:sdb].put_attributes(@domain_name, 'buzz', { "attr" => "foo" })
      AWS[:sdb].put_attributes(@domain_name, 'buzz', { "attr" => "foo2" })
      Fog.wait_for do
        actual = AWS[:sdb].get_attributes(@domain_name, 'buzz')
        actual.body["Attributes"]["attr"] == ['foo', 'foo2']
      end
    end

    it 'should have attributes for foo after put_attributes' do
      AWS[:sdb].put_attributes(@domain_name, 'foo', { :bar => :baz })
      Fog.wait_for do
        actual = AWS[:sdb].get_attributes(@domain_name, 'foo')
        actual.body['Attributes'] == { 'bar' => ['baz'] }
      end
    end

    context "foo item is put with bar attribute as an array" do
      it "should return the array for foo's bar attribute" do
        the_array = %w{A B C}
        AWS[:sdb].put_attributes(@domain_name, 'foo', { :bar => the_array })
        Fog.wait_for do
          actual = AWS[:sdb].get_attributes(@domain_name, 'foo')
          actual.body['Attributes']['bar'] == the_array
        end
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
