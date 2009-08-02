require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'S3.buckets' do

  it "should return buckets from all" do
    p s3.buckets.all
  end

  it "should return bucket from get" do
    p s3.buckets.get('monki')
  end

end