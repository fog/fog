require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../../../shared_examples/servers_examples'

describe 'Fog::Rackspace::Servers::Servers' do

  it_should_behave_like "Servers"

  # flavor 1 = 256, image 3 = gentoo 2008.0
  subject { @server = @servers.new(:flavor_id => 1, :image_id => 3, :name => 'name') }

  before(:each) do
    @servers = Rackspace[:servers].servers
  end

  after(:each) do
    if @server && !@server.new_record?
      @server.wait_for { ready? }
      @server.destroy.should be_true
    end
  end

end
