require 'fog/openstack/compute'
require 'fog/openstack/identity'
require 'fog/openstack/identity_v3'
require 'fog/openstack/volume'
require 'rspec/core'
require 'rspec/expectations'
require 'vcr'

RSpec.describe Fog::Volume::OpenStack do

  before :all do
    # FIXME code duplication with "before :all" of identity_v3_spec.rb
    @os_auth_url = ENV['OS_AUTH_URL']

    if @os_auth_url
      # if OS_AUTH_URL is set but FOG_MOCK is not, don't record anything and just pass through the requests
      VCR.configure do |c|
        c.ignore_request do |request|
          ENV['FOG_MOCK']!='true' && !ENV['OS_AUTH_URL'].nil?
        end
      end
    else
      # Fail-safe URL which matches the VCR recordings
      @os_auth_url = 'http://devstack.openstack.stack:5000/v2.0'
      # when using the cassettes, there is no need to sleep in wait_for()
      Fog.interval = 0
    end

    VCR.configure do |config|
      config.allow_http_connections_when_no_cassette = true
      config.hook_into :webmock

      if ENV['DEBUG']
        config.ignore_request do |request|
          false && !ENV['OS_AUTH_URL'].nil?
        end
        config.cassette_library_dir = "spec/debug"
        config.default_cassette_options.merge! :record => :all
      else
        config.cassette_library_dir = "spec/fog/openstack/volume"
        config.default_cassette_options = {:record => :none}
        config.default_cassette_options.merge! :match_requests_on => [:method, :uri, :body] unless RUBY_VERSION =~ /1.8/ # Ruby 1.8.7 encodes JSON differently, which screws up request matching
      end
    end

    # Allow us to ignore dev certificates on servers
    Excon.defaults[:ssl_verify_peer] = false if ENV['SSL_VERIFY_PEER'] == 'false'

    VCR.use_cassette('volume_common_setup') do
      @service = Fog::Volume::OpenStack.new(
        :openstack_auth_url       => "#{@os_auth_url}/tokens",
        :openstack_region         => ENV['OS_REGION_NAME']         || 'RegionOne',
        :openstack_api_key        => ENV['OS_PASSWORD']            || 'devstack',
        :openstack_username       => ENV['OS_USERNAME']            || 'admin',
        :openstack_tenant         => ENV['OS_PROJECT_NAME']        || 'admin'
        # FIXME: Identity V3 not properly supported by this call yet
        # :openstack_user_domain    => ENV['OS_USER_DOMAIN_NAME']    || 'Default',
        # :openstack_project_domain => ENV['OS_PROJECT_DOMAIN_NAME'] || 'Default',
      ) unless @service
    end
  end

  it 'CRUD volumes' do
    VCR.use_cassette('volume_crud') do

      volume_name = "fog-testvolume-1"
      volume_description = 'This is the volume description.'
      volume_size = 1 # in GB

      # if any of these expectations fail, that means you have left-over
      # objects from your previous failed test run
      puts "Checking for leftovers..." if ENV['DEBUG_VERBOSE']
      expect(@service.volumes.all(:display_name => volume_name).length).to be 0

      # create volume
      puts "Creating volume..." if ENV['DEBUG_VERBOSE']
      volume_id = @service.volumes.create(
        :display_name        => volume_name,
        :display_description => volume_description,
        :size                => volume_size
      ).id
      expect(@service.volumes.all(:display_name => volume_name).length).to be 1

      # check retrieval of volume by ID
      puts "Retrieving volume by ID..." if ENV['DEBUG_VERBOSE']

      volume = @service.volumes.get(volume_id)
      expect(volume).to be_a(Fog::Volume::OpenStack::Volume)

      expect(volume.id).to eq(volume_id)
      expect(volume.display_name).to eq(volume_name)
      expect(volume.display_description).to eq(volume_description)
      expect(volume.size).to eq(volume_size)

      puts "Waiting for volume to be available..." if ENV['DEBUG_VERBOSE']
      volume.wait_for { ready? }

      # check retrieval of volume by name
      puts "Retrieving volume by name..." if ENV['DEBUG_VERBOSE']

      volumes = @service.volumes.all(:display_name => volume_name)
      expect(volumes).to contain_exactly(an_instance_of(Fog::Volume::OpenStack::Volume))
      volume = volumes[0]

      expect(volume.id).to eq(volume_id)
      expect(volume.display_name).to eq(volume_name)
      expect(volume.display_description).to eq(volume_description)
      expect(volume.size).to eq(volume_size)

      # delete volume
      puts "Deleting volume..." if ENV['DEBUG_VERBOSE']

      @service.delete_volume(volume_id)

      Fog.wait_for do # wait for the volume to be deleted
        begin
          volume = @service.volumes.get(volume_id)
          puts "Current volume status: #{volume ? volume.status : 'deleted'}" if ENV['DEBUG_VERBOSE']
          false
        rescue Fog::Compute::OpenStack::NotFound # FIXME: Why is this "Compute", not "Volume"? Copy-paste error?
          true
        end
      end

    end
  end

  it 'reads volume types' do
    VCR.use_cassette('volume_type_read') do

      # list all volume types
      puts "Listing volume types..." if ENV['DEBUG_VERBOSE']

      types = @service.volume_types.all
      expect(types.length).to be > 0
      types.each do |type|
        expect(type.name).to be_a(String)
      end

      type_id   = types[0].id
      type_name = types[0].name

      # get a single volume type by ID
      puts "Retrieving volume type by ID..." if ENV['DEBUG_VERBOSE']

      type = @service.volume_types.get(type_id)
      expect(type).to be_a(Fog::Volume::OpenStack::VolumeType)
      expect(type.id).to eq(type_id)
      expect(type.name).to eq(type_name)

      # get a single volume type by name
      puts "Retrieving volume type by name..." if ENV['DEBUG_VERBOSE']

      type = @service.volume_types.all(type_name).first
      expect(type).to be_a(Fog::Volume::OpenStack::VolumeType)
      expect(type.id).to eq(type_id)
      expect(type.name).to eq(type_name)

    end
  end

  # TODO: tests for snapshots
  # TODO: tests for quotas

end
