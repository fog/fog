require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::Google::Storage::Directories' do

  describe "#all" do

    it "should include persisted directories" do
      @directory = Google[:storage].directories.create(:key => 'fogdirectorykey')
      Google[:storage].directories.all.map {|directory| @directory.key}.should include('fogdirectorykey')
      @directory.destroy
    end

  end

  describe "#create" do

     it "should exist on s3" do
       directory = Google[:storage].directories.create(:key => 'fogdirectorykey')
       Google[:storage].directories.get(directory.key).should_not be_nil
       directory.destroy
     end

   end

   describe "#get" do

     it "should return a Fog::Google::Storage::Directory if a matching directory exists" do
       directory = Google[:storage].directories.create(:key => 'fogdirectorykey')
       get = Google[:storage].directories.get('fogdirectorykey')
       directory.attributes.should == get.attributes
       directory.destroy
     end

     it "should return nil if no matching directory exists" do
       Google[:storage].directories.get('fognotadirectory').should be_nil
     end

   end

   describe "#reload" do

     it "should reload data" do
       directories = Google[:storage].directories
       directories.should == directories.reload
     end

   end

end
