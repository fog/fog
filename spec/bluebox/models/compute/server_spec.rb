require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../../../shared_examples/server_examples'

describe 'Fog::Bluebox::Compute::Server' do

  if Fog.mocking?
    it "needs to have mocks implemented"
  else
    it_should_behave_like "Server"
  end

  subject {
    @flavor_id  = '94fd37a7-2606-47f7-84d5-9000deda52ae' # Block 1GB Virtual Server
    @image_id   = 'a00baa8f-b5d0-4815-8238-b471c4c4bf72' # Ubuntu 9.10 64bit
    @server = @servers.new(:flavor_id => @flavor_id, :image_id => @image_id, :password => "chunkybacon")
  }

  before(:each) do
    @servers = Bluebox[:compute].servers
  end

  after(:each) do
    if @server && !@server.new_record?
      @server.wait_for { ready? }
      @server.destroy.should be_true
    end
  end

end
