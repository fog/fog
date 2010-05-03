require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::S3::Directories' do

  describe "#all" do

    it "should include persisted directories" do
      @directory = AWS[:s3].directories.create(:key => 'fogdirectorykey')
      AWS[:s3].directories.all.map {|directory| @directory.key}.should include('fogdirectorykey')
      @directory.destroy
    end

  end

  describe "#create" do

    it "should exist on s3" do
      directory = AWS[:s3].directories.create(:key => 'fogdirectorykey')
      AWS[:s3].directories.get(directory.key).should_not be_nil
      directory.destroy
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::S3::Directory if a matching directory exists" do
      directory = AWS[:s3].directories.create(:key => 'fogdirectorykey')
      get = AWS[:s3].directories.get('fogdirectorykey')
      directory.attributes.should == get.attributes
      directory.destroy
    end

    it "should return nil if no matching directory exists" do
      AWS[:s3].directories.get('fognotadirectory').should be_nil
    end

  end

  describe "#reload" do

    it "should reload data" do
      directories = AWS[:s3].directories
      directories.should == directories.reload
    end

  end

end
