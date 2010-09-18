require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../../../../lib/fog/google/models/storage/directory'

describe 'Fog::Google::Storage::Directory' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      now = Time.now
      directory = Fog::Google::Storage::Directory.new(
        'CreationDate' => now,
        'Name'         => 'directorykey'
      )
      directory.creation_date.should == now
      directory.key.should == 'directorykey'
    end

  end

  describe "#collection" do

    it "should be the directories the directory is related to" do
      directories = Google[:storage].directories
      directories.new.collection.should == directories
    end

  end

  describe "#destroy" do

    it "should return true if the directory is deleted" do
      directory = Google[:storage].directories.create(:key => 'fogmodeldirectory')
      directory.destroy.should be_true
    end

    it "should return false if the directory does not exist" do
      directory = Google[:storage].directories.new(:key => 'fogmodeldirectory')
      directory.destroy.should be_false
    end

  end

  describe "#reload" do

    before(:each) do
      @directory = Google[:storage].directories.create(:key => 'fogmodeldirectory')
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
      @directory = Google[:storage].directories.new(:key => 'fogmodeldirectory')
    end

    it "should not exist in directories before save" do
      Google[:storage].directories.all.map {|directory| directory.key}.include?(@directory.key).should be_false
    end

    it "should return true when it succeeds" do
      @directory.save.should be_true
      @directory.destroy
    end

    it "should exist in directories after save" do
      @directory.save
      Google[:storage].directories.all.map {|directory| directory.key}.include?(@directory.key).should be_true
      @directory.destroy
    end

  end

end
