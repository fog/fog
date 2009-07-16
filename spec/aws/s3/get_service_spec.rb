require File.dirname(__FILE__) + '/../../spec_helper'

describe 'S3.get_service' do

  before(:all) do
    s3.put_bucket('foggetservice')
  end

  after(:all) do
    s3.delete_bucket('foggetservice')
  end

  it 'should return proper_attributes' do
    actual = s3.get_service
    actual.status.should == 200
    actual.body[:owner][:display_name].should be_a(String)
    actual.body[:owner][:id].should be_a(String)
    actual.body[:buckets].should be_an(Array)
    bucket = actual.body[:buckets].select {|bucket| bucket[:name] == 'foggetservice'}.first
    bucket[:creation_date].should be_a(Time)
    bucket[:name].should == 'foggetservice'
  end

  it 'should include foggetservice in get_service' do
    eventually do
      actual = s3.get_service
      actual.body[:buckets].collect { |bucket| bucket[:name] }.should include('foggetservice')
    end
  end

end
