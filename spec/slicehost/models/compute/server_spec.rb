require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../../../shared_examples/server_examples'

describe 'Fog::Slicehost::Compute::Server' do

  if Fog.mocking?
    it "needs to have mocks implemented"
  else
    it_should_behave_like "Server"
  end

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

  describe "#initialize" do

    it "should remap attributes from parser" do
      server = @servers.new({
        'addresses'       => 'addresses',
        'backup-id'       => 'backup_id',
        'bw-in'           => 'bw_in',
        'bw-out'          => 'bw_out',
        'flavor-id'       => 'flavor_id',
        'image-id'        => 'image_id',
        'name'            => 'name',
        'root-password'   => 'password',
        'progress'        => 'progress',
        'status'          => 'status'
      })
      server.addresses.should == 'addresses'
      server.backup_id.should == 'backup_id'
      server.bandwidth_in.should == 'bw_in'
      server.bandwidth_out.should == 'bw_out'
      server.flavor_id.should == 'flavor_id'
      server.image_id.should == 'image_id'
      server.name.should == 'name'
      server.password.should == 'password'
      server.progress.should == 'progress'
      server.status.should == 'status'
    end

  end

end
