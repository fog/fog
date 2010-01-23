require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::EC2::Servers' do

  subject { @server = @servers.create(:image_id => GENTOO_AMI) }

  before(:each) do
    @servers = AWS[:ec2].servers
  end

  after(:each) do
    if @server && !@server.new_record?
      @server.destroy
    end
  end

  describe "#all" do

    it "should include persisted servers" do
      eventually do
        @servers.all.map {|server| server.id}.should include(subject.id)
      end
    end

  end

  describe "#get" do

    it "should return a matching server if one exists" do
      eventually do
        get = @servers.get(subject.id)
        subject.attributes.should == get.attributes
      end
    end

    it "should return nil if no matching server exists" do
      @servers.get('i-00000000').should be_nil
    end

  end

  describe "#reload" do

    it "should reset attributes to remote state" do
      servers = @servers.all
      reloaded = servers.reload
      servers.attributes.should == reloaded.attributes
    end

  end

end
