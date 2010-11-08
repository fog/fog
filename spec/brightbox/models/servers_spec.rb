require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../shared_examples/servers_examples'

describe 'Fog::Brightbox::Compute::Servers' do

  if Fog.mocking?
    it "needs to have mocks implemented"
  else
    it_should_behave_like "Servers"
  end

  subject {
    @image_id = "img-9vxqi" # Ubuntu Maverick 10.10 server
    @server = @servers.new(:image_id => @image_id)
    @server
  }

  before(:each) do
    @servers = Brightbox[:compute].servers
  end

  after(:each) do
    if @server && !@server.new_record?
      @server.wait_for { ready? }
      @server.destroy.should be_true
    end
  end

end