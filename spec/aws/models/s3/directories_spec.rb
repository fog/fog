require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::S3::Directories' do

  describe "#all" do

    it "should include persisted directories" do
      @directory = AWS[:s3].directories.create(:name => 'fogdirectoryname')
      AWS[:s3].directories.all.map {|directory| @directory.name}.should include('fogdirectoryname')
      @directory.destroy
    end

  end

  describe "#create" do

    it "should exist on s3" do
      directory = AWS[:s3].directories.create(:name => 'fogdirectoryname')
      AWS[:s3].directories.get(directory.name).should_not be_nil
      directory.destroy
    end

  end

  describe "#get" do

    it "should return a Fog::AWS::S3::Directory if a matching directory exists" do
      directory = AWS[:s3].directories.create(:name => 'fogdirectoryname')
      get = AWS[:s3].directories.get('fogdirectoryname')
      directory.attributes.should == get.attributes
      directory.destroy
    end

    it "should return nil if no matching directory exists" do
      AWS[:s3].directories.get('fogdirectoryname').should be_nil
    end

  end

  describe "#reload" do

    it "should reload data" do
      directories = AWS[:s3].directories
      directories.should == directories.reload
    end

  end

end
