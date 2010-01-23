require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../../../shared_examples/server_examples'

describe 'Fog::AWS::EC2::Server' do

  it_should_behave_like "Server"

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

  describe "#initialize" do

    it "should remap attributes from parser" do
      server = @servers.new({
        'addresses'   => 'addresses',
        'adminPass'   => 'password',
        'flavorId'    => 'flavor_id',
        'hostId'      => 'host_id',
        'imageId'     => 'image_id',
        'metadata'    => 'metadata',
        'name'        => 'name',
        'personality' => 'personality',
        'progress'    => 'progress',
        'status'      => 'status'
      })
      server.addresses.should == 'addresses'
      server.password.should == 'password'
      server.flavor_id.should == 'flavor_id'
      server.host_id.should == 'host_id'
      server.image_id.should == 'image_id'
      server.metadata.should == 'metadata'
      server.name.should == 'name'
      server.personality.should == 'personality'
      server.progress.should == 'progress'
      server.status.should == 'status'
    end

  end

end
