require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../../../shared_examples/servers_examples'

describe 'Fog::AWS::Compute::Servers' do

  it_should_behave_like "Servers"

  subject { @server = @servers.new(:image_id => GENTOO_AMI) }

  before(:each) do
    @servers = AWS[:compute].servers
  end

  after(:each) do
    if @server && !@server.new_record?
      @server.wait_for { ready? }
      @server.destroy.should be_true
    end
  end

end
