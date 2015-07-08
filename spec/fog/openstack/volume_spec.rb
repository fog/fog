require 'fog/openstack/compute'
require 'fog/openstack/identity'
require 'fog/openstack/identity_v3'
require 'fog/openstack/volume'

if RUBY_VERSION =~ /1.8/
  require File.expand_path('../shared_context', __FILE__)
else
  require_relative './shared_context'
end

RSpec.describe Fog::Volume::OpenStack do

  include_context 'OpenStack specs with VCR'
  before :all do
    setup_vcr_and_service(
      :vcr_directory => 'spec/fog/openstack/volume',
      :service_class => Fog::Volume::OpenStack
    )
  end

  def setup_test_object(options)
    type = options.delete(:type)
    case type
      when :volume
        puts "Checking for leftovers..." if ENV['DEBUG_VERBOSE']
        volume_name = options[:display_name]
        # if this fails, cleanup this object (it was left over from a failed test run)
        expect(@service.volumes.all(:display_name => volume_name).length).to be(0)

        puts "Creating volume #{volume_name}..." if ENV['DEBUG_VERBOSE']
        return @service.volumes.create(options)
      else
        raise ArgumentError, "don't know how to setup a test object of type #{type.inspect}"
    end
  end

  def cleanup_test_object(collection, id)
    # has the object already been deleted?
    begin
      object = collection.get(id)
    rescue Fog::Compute::OpenStack::NotFound # "Compute", not "Volume"; see issue #3618
      true
    end

    puts "Deleting object #{object.class} #{id}..." if ENV['DEBUG_VERBOSE']
    object.destroy

    # wait for the object to be deleted
    Fog.wait_for do
      begin
        object = collection.get(id)
        puts "Current status: #{object ? object.status : 'deleted'}" if ENV['DEBUG_VERBOSE']
        false
      rescue Fog::Compute::OpenStack::NotFound # "Compute", not "Volume"; see issue #3618
        true
      end
    end
  end

  it 'CRUD volumes' do
    VCR.use_cassette('volume_crud') do

      volume_name = "fog-testvolume-1"
      volume_description = 'This is the volume description.'
      volume_size = 1 # in GB

      # create volume
      volume_id = setup_test_object(:type => :volume,
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
      expect(volumes.length).to be 1
      volume = volumes[0]
      expect(volume).to be_a(Fog::Volume::OpenStack::Volume)

      expect(volume.id).to eq(volume_id)
      expect(volume.display_name).to eq(volume_name)
      expect(volume.display_description).to eq(volume_description)
      expect(volume.size).to eq(volume_size)

      # delete volume
      cleanup_test_object(@service.volumes, volume_id)
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

  it 'can extend volumes' do
    VCR.use_cassette('volume_extend') do

      volume_size_small  = 1 # in GB
      volume_size_large  = 2 # in GB

      volume = setup_test_object(:type => :volume,
        :display_name => 'fog-testvolume-1',
        :size         => volume_size_small
      )
      volume.wait_for { ready? and size == volume_size_small }

      # extend volume
      puts "Extending volume..." if ENV['DEBUG_VERBOSE']
      volume.extend(volume_size_large)
      volume.wait_for { ready? and size == volume_size_large }

      # shrinking is not allowed in OpenStack
      puts "Shrinking volume should fail..." if ENV['DEBUG_VERBOSE']
      expect { volume.extend(volume_size_small) }.to raise_error(Excon::Errors::BadRequest, /Invalid input received: New size for extend must be greater than current size./)

      # delete volume
      cleanup_test_object(@service.volumes, volume.id)

      # check that extending a non-existing volume fails
      puts "Extending deleted volume should fail..." if ENV['DEBUG_VERBOSE']
      expect { @service.extend_volume(volume.id, volume_size_small) }.to raise_error(Fog::Compute::OpenStack::NotFound)
    end
  end

  # TODO: tests for snapshots
  # TODO: tests for quotas

end
