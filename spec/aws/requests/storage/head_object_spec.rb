require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Storage.head_object' do
  describe 'success' do

    before(:each) do
      AWS[:storage].put_bucket('fogheadobject')
      AWS[:storage].put_object('fogheadobject', 'fog_head_object', lorem_file)
    end

    after(:each) do
      AWS[:storage].delete_object('fogheadobject', 'fog_head_object')
      AWS[:storage].delete_bucket('fogheadobject')
    end

    it 'should return proper attributes' do
      actual = AWS[:storage].head_object('fogheadobject', 'fog_head_object')
      actual.status.should == 200
      data = lorem_file.read
      actual.headers['Content-Length'].should == data.length.to_s
      actual.headers['ETag'].should be_a(String)
      actual.headers['Last-Modified'].should be_a(String)
    end

  end
end
