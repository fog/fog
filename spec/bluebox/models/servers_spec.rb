require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../shared_examples/servers_examples'

describe 'Fog::Bluebox::Servers' do

  it_should_behave_like "Servers"

  it "should have the proper status after a create call" do
    subject.save
    new_server = @servers.get(subject.id)
    subject.status.should == "queued"
    new_server.status.should == "queued"
  end

  # flavor 1 = 256, image 3 = gentoo 2008.0
  subject {
    @flavor_id = "94fd37a7-2606-47f7-84d5-9000deda52ae" # Block 1GB Virtual Server
    @image_id = "03807e08-a13d-44e4-b011-ebec7ef2c928"  # Ubuntu 10.04 x64 LTS
    @server = @servers.new(:flavor_id => @flavor_id, :image_id => @image_id, :name => Time.now.to_i.to_s, :password => "chunkybacon")
    @server
  }

  before(:each) do
    @servers = Bluebox[:blocks].servers
  end

  after(:each) do
    if @server && !@server.new_record?
      @server.wait_for { ready? }
      @server.destroy.should be_true
    end
  end

end
