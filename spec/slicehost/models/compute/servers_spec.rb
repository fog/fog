require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../../../shared_examples/servers_examples'

describe 'Fog::Slicehost::Compute::Servers' do

  it_should_behave_like "Servers"

  # flavor 1 = 256, image 49 = Ubuntu 10.04 LTS (lucid)
  subject { @server = @servers.new(:flavor_id => 1, :image_id => 49, :name => Time.now.to_i.to_s) }

  before(:each) do
    @servers = Slicehost[:compute].servers
  end

  after(:each) do
    if @server && !@server.new_record?
      @server.wait_for { ready? }
      @server.destroy.should be_true
    end
  end

end
