require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../shared_examples/server_examples'

describe 'Fog::Bluebox::Server' do

  it_should_behave_like "Server"

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

  describe "#initialize" do

    it "should remap attributes from parser" do
      server = @servers.new({
        'ips'             => 'ips',
        'image_id'        => 'image_id',
        'flavor_id'       => 'flavor_id',
        'cpu'             => 'cpu',
        'memory'          => 'memory',
        'storage'         => 'storage',
        'hostname'        => 'hostname',
        'status'          => 'status'
      })
      server.ips.should == 'ips'
      server.flavor_id.should == 'flavor_id'
      server.image_id.should == 'image_id'
      server.cpu.should == 'cpu'
      server.memory.should == 'memory'
      server.storage.should == 'storage'
      server.hostname.should == 'hostname'
      server.status.should == 'status'
    end

  end

end
