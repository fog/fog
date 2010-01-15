require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::S3::Directory' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      now = Time.now
      directory = Fog::AWS::S3::Directory.new(
        'CreationDate' => now,
        'Name'         => 'directoryname'
      )
      directory.creation_date.should == now
      directory.name.should == 'directoryname'
    end

  end

  describe "#collection" do

    it "should be the directories the directory is related to" do
      directories = s3.directories
      directories.new.collection.should == directories
    end

  end

  describe "#destroy" do

    it "should return true if the directory is deleted" do
      directory = s3.directories.create(:name => 'fogmodeldirectory')
      directory.destroy.should be_true
    end

    it "should return false if the directory does not exist" do
      directory = s3.directories.new(:name => 'fogmodeldirectory')
      directory.destroy.should be_false
    end

  end

  describe "#location" do

    it "should return the location constraint" do
      directory = s3.directories.create(:name => 'fogmodeleudirectory', :location => 'EU')
      directory.location.should == 'EU'
      eu_s3.directories.get('fogmodeleudirectory').destroy
    end

  end

  describe "#payer" do

    it "should return the request payment value" do
      directory = s3.directories.create(:name => 'fogmodeldirectory')
      directory.payer.should == 'BucketOwner'
      directory.destroy.should be_true
    end

  end

  describe "#payer=" do

    it "should set the request payment value" do
      directory = s3.directories.create(:name => 'fogmodeldirectory')
      (directory.payer = 'Requester').should == 'Requester'
      directory.destroy.should
    end

  end

  describe "#reload" do

    before(:each) do
      @directory = s3.directories.create(:name => 'fogmodeldirectory')
      @reloaded = @directory.reload
    end

    after(:each) do
      @directory.destroy
    end

    it "should reset attributes to remote state" do
      @directory.attributes.should == @reloaded.attributes
    end

  end

  describe "#save" do

    before(:each) do
      @directory = s3.directories.new(:name => 'fogmodeldirectory')
    end

    it "should return true when it succeeds" do
      @directory.save.should be_true
      @directory.destroy
    end

    it "should not exist in directories before save" do
      s3.directories.all.map {|directory| directory.name}.include?(@directory.name).should be_false
    end

    it "should exist in directories after save" do
      @directory.save
      s3.directories.all.map {|directory| directory.name}.include?(@directory.name).should be_true
      @directory.destroy
    end

  end

end
