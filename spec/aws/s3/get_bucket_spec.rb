require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.get_bucket' do

  before(:all) do
    s3.put_bucket('foggetbucket')
    file = File.open(File.dirname(__FILE__) + '/../../lorem.txt', 'r')
    s3.put_object('foggetbucket', 'fog_get_bucket', file)
  end

  after(:all) do
    s3.delete_object('foggetbucket', 'fog_get_bucket')
    s3.delete_bucket('foggetbucket')
  end

  it 'should return proper attributes' do
    actual = s3.get_bucket('foggetbucket')
    actual.status.should == 200
    actual.body[:name].should be_a(String)
    actual.body[:is_truncated].should == false
    actual.body[:marker].should be_a(String)
    actual.body[:max_keys].should be_an(Integer)
    actual.body[:prefix].should be_a(String)
    actual.body[:contents].should be_an(Array)
    object = actual.body[:contents].first
    object[:key].should == 'fog_get_bucket'
    object[:last_modified].should be_a(Time)
    object[:owner][:display_name].should be_a(String)
    object[:owner][:id].should be_a(String)
    object[:size].should be_an(Integer)
    object[:storage_class].should be_a(String)
  end

end
