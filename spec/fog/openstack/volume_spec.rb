require 'fog/openstack/compute'
require 'fog/openstack/identity'
require 'fog/openstack/identity_v3'
require 'fog/openstack/volume'
require 'fog/openstack/shared_context'

[Fog::Volume::OpenStack,
 Fog::Volume::OpenStack::V1,
 Fog::Volume::OpenStack::V2].delete_if{|_class| ENV['TEST_CLASS'] && ENV['TEST_CLASS'] != _class.name}.each do |service_class|
 RSpec.describe service_class do
  include_context 'OpenStack specs with VCR'
  before :all do
    vcr_directory = 'spec/fog/openstack/volume' if service_class == Fog::Volume::OpenStack

    vcr_directory = 'spec/fog/openstack/volume_v1' if service_class == Fog::Volume::OpenStack::V1

    vcr_directory = 'spec/fog/openstack/volume_v2' if service_class == Fog::Volume::OpenStack::V2

    setup_vcr_and_service(
        :vcr_directory => vcr_directory,
        :service_class => service_class
    )

    # Account for the different parameter naming between v1 and v2 services
    @name_param = :display_name unless v2?
    @name_param = :name if v2?
    
    @description_param = :display_description unless v2?
    @description_param = :description if v2?
  end

  def v2?
    @service.is_a? Fog::Volume::OpenStack::V2::Real
  end

  def setup_test_object(options)
    type = options.delete(:type)
    case type
      when :volume
        puts "Checking for leftovers..." if ENV['DEBUG_VERBOSE']
        volume_name = options[@name_param]
        # if this fails, cleanup this object (it was left over from a failed test run)
        expect(@service.volumes.all(@name_param => volume_name).length).to be(0)

        puts "Creating volume #{volume_name}..." if ENV['DEBUG_VERBOSE']
        return @service.volumes.create(options)

      when :transfer
        puts "Checking for leftovers..." if ENV['DEBUG_VERBOSE']
        transfer_name = options[:name]
        # if this fails, cleanup this object (it was left over from a failed test run)
        expect(@service.transfers.all(:name => transfer_name).length).to be(0)

        puts "Creating transfer #{transfer_name}..." if ENV['DEBUG_VERBOSE']
        return @service.transfers.create(options)

      else
        raise ArgumentError, "don't know how to setup a test object of type #{type.inspect}"
    end
  end

  def cleanup_test_object(collection, id)

    # wait for the object to be deletable
    Fog.wait_for do
      begin
        object = collection.get(id)
        puts "Current status: #{object ? object.status : 'deleted'}" if ENV['DEBUG_VERBOSE']
        object.nil? || (['available', 'error'].include? object.status.downcase)
      end
    end

    object = collection.get(id)
    puts "Deleting object #{object.class} #{id}..." if ENV['DEBUG_VERBOSE']
    object.destroy if object

    # wait for the object to be deleted
    Fog.wait_for do
      begin
        object = collection.get(id)
        puts "Current status: #{object ? object.status : 'deleted'}" if ENV['DEBUG_VERBOSE']
        object.nil?
      end
    end
  end

  it 'CRUD volumes' do
    VCR.use_cassette('volume_crud') do
      begin
        volume_name        = "fog-testvolume-1"
        volume_description = 'This is the volume description.'
        volume_size        = 1 # in GB

        # create volume
        volume_id          = setup_test_object(:type                => :volume,
                                               @name_param        => volume_name,
                                               @description_param => volume_description,
                                               :size                => volume_size
        ).id

        expect(@service.volumes.all(@name_param => volume_name).length).to be 1

        # check retrieval of volume by ID
        puts "Retrieving volume by ID..." if ENV['DEBUG_VERBOSE']

        volume = @service.volumes.get(volume_id)
        expect(volume).to be_a(Fog::Volume::OpenStack::Volume)

        expect(volume.id).to eq(volume_id)
        expect(volume.display_name).to eq(volume_name) unless v2?
        expect(volume.name).to eq(volume_name) if v2?
        expect(volume.display_description).to eq(volume_description) unless v2?
        expect(volume.description).to eq(volume_description) if v2?
        expect(volume.size).to eq(volume_size)

        puts "Waiting for volume to be available..." if ENV['DEBUG_VERBOSE']
        volume.wait_for { ready? }

        # check retrieval of volume by name
        puts "Retrieving volume by name..." if ENV['DEBUG_VERBOSE']

        volumes = @service.volumes.all(@name_param => volume_name)
        expect(volumes.length).to be 1
        volume = volumes[0]
        expect(volume).to be_a(Fog::Volume::OpenStack::Volume)

        expect(volume.id).to eq(volume_id)
        expect(volume.display_name).to eq(volume_name) unless v2?
        expect(volume.name).to eq(volume_name) if v2?
        expect(volume.display_description).to eq(volume_description) unless v2?
        expect(volume.description).to eq(volume_description) if v2?
        expect(volume.size).to eq(volume_size)
      ensure
        # delete volume
        cleanup_test_object(@service.volumes, volume_id)
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

  it 'can extend volumes' do
    VCR.use_cassette('volume_extend') do
      begin
        volume_size_small = 1 # in GB
        volume_size_large = 2 # in GB

        volume = setup_test_object(:type         => :volume,
                                   @name_param => 'fog-testvolume-1',
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
      ensure
        # delete volume
        cleanup_test_object(@service.volumes, volume.id)

        # check that extending a non-existing volume fails
        puts "Extending deleted volume should fail..." if ENV['DEBUG_VERBOSE']
        expect { @service.extend_volume(volume.id, volume_size_small) }.to raise_error(Fog::Volume::OpenStack::NotFound)
      end
    end
  end

  it 'can create and accept volume transfers' do
    VCR.use_cassette('volume_transfer_and_accept') do
      begin
        transfer_name = 'fog-testtransfer-1'

        # create volume object
        volume        = setup_test_object(:type         => :volume,
                                          @name_param => 'fog-testvolume-1',
                                          :size         => 1
        )
        volume.wait_for { ready? }

        # create transfer object
        transfer    = setup_test_object(:type      => :transfer,
                                        :name      => transfer_name,
                                        :volume_id => volume.id
        )
        # we need to save the auth_key NOW, it's only present in the response
        # from the create_transfer request
        auth_key    = transfer.auth_key
        transfer_id = transfer.id

        # check retrieval of transfer by ID
        puts 'Retrieving transfer by ID...' if ENV['DEBUG_VERBOSE']

        transfer = @service.transfers.get(transfer_id)
        expect(transfer).to be_a(Fog::Volume::OpenStack::Transfer)

        expect(transfer.id).to eq(transfer_id)
        expect(transfer.name).to eq(transfer_name)
        expect(transfer.volume_id).to eq(volume.id)

        # check retrieval of transfer by name
        puts 'Retrieving transfer by name...' if ENV['DEBUG_VERBOSE']

        transfers = @service.transfers.all(:name => transfer_name)
        expect(transfers.length).to be(1)
        transfer = transfers[0]
        expect(transfer).to be_a(Fog::Volume::OpenStack::Transfer)

        expect(transfer.id).to eq(transfer_id)
        expect(transfer.name).to eq(transfer_name)
        expect(transfer.volume_id).to eq(volume.id)

        # to accept the transfer, we need a second connection to a different project
        puts 'Checking object visibility from different projects...' if ENV['DEBUG_VERBOSE']
        other_service = @service.class.new(
            :openstack_auth_url     => "#{@os_auth_url}/auth/tokens",
            :openstack_region       => ENV['OS_REGION_NAME'] || 'RegionOne',
            :openstack_api_key      => ENV['OS_PASSWORD_OTHER'] || 'password',
            :openstack_username     => ENV['OS_USERNAME_OTHER'] || 'demo',
            :openstack_domain_name  => ENV['OS_USER_DOMAIN_NAME'] || 'Default',
            :openstack_project_name => ENV['OS_PROJECT_NAME_OTHER'] || 'demo'
        )

        # check that recipient cannot see the transfer object
        expect(other_service.transfers.get(transfer.id)).to be_nil
        expect(other_service.transfers.all(:name => transfer_name).length).to be(0)

        # # check that recipient cannot see the volume before transfer
        # expect { other_service.volumes.get(volume.id) }.to raise_error(Fog::Compute::OpenStack::NotFound)
        # expect(other_service.volumes.all(@name_param => volume_name).length).to be(0)

        # The recipient can inexplicably see the volume even before the
        # transfer, so to confirm that the transfer happens, we record its tenant ID.
        expect(volume.tenant_id).to match(/^[0-9a-f-]+$/) # should look like a UUID
        source_tenant_id = volume.tenant_id

        # check that accept_transfer fails without valid transfer ID and auth key
        bogus_uuid       = 'ec8ff7e8-81e2-4e12-b9fb-3e8890612c2d' # generated by Fog::UUID.uuid, but fixed to play nice with VCR
        expect { other_service.transfers.accept(bogus_uuid, auth_key) }.to raise_error(Fog::Volume::OpenStack::NotFound)
        expect { other_service.transfers.accept(transfer_id, 'invalidauthkey') }.to raise_error(Excon::Errors::BadRequest)

        # accept transfer
        puts 'Accepting transfer...' if ENV['DEBUG_VERBOSE']
        transfer = other_service.transfers.accept(transfer.id, auth_key)
        expect(transfer).to be_a(Fog::Volume::OpenStack::Transfer)

        expect(transfer.id).to eq(transfer_id)
        expect(transfer.name).to eq(transfer_name)

        # check that recipient can see the volume
        volume = other_service.volumes.get(volume.id)
        expect(volume).to be_a(Fog::Volume::OpenStack::Volume)

        # # check that sender cannot see the volume anymore
        # expect { @service.volumes.get(volume.id) }.to raise_error(Fog::Compute::OpenStack::NotFound)
        # expect(@service.volumes.all(@name_param => volume_name).length).to be(0)

        # As noted above, both users seem to be able to see the volume at all times.
        # Check change of ownership by looking at the tenant_id, instead.
        expect(volume.tenant_id).to match(/^[0-9a-f-]+$/) # should look like a UUID
        expect(volume.tenant_id).not_to eq(source_tenant_id)

        # check that the transfer object is gone on both sides
        [@service, other_service].each do |service|
          expect(service.transfers.get(transfer.id)).to be_nil
          expect(service.transfers.all(:name => transfer_name).length).to be(0)
        end
      ensure
        # cleanup volume
        cleanup_test_object(other_service.volumes, volume.id)
      end
    end
  end

  it 'can create and delete volume transfers' do
    VCR.use_cassette('volume_transfer_and_delete') do
      begin
        # create volume object
        volume = setup_test_object(:type         => :volume,
                                   @name_param => 'fog-testvolume-1',
                                   :size         => 1
        )
        volume.wait_for { ready? }

        # create transfer object
        transfer      = setup_test_object(:type      => :transfer,
                                          :name      => 'fog-testtransfer-1',
                                          :volume_id => volume.id
        )
        # we need to save the auth_key NOW, it's only present in the response
        # from the create_transfer request
        auth_key      = transfer.auth_key
        transfer_id   = transfer.id

        # to try to accept the transfer, we need a second connection to a different project
        other_service = @service.class.new(
            :openstack_auth_url     => "#{@os_auth_url}/auth/tokens",
            :openstack_region       => ENV['OS_REGION_NAME'] || 'RegionOne',
            :openstack_api_key      => ENV['OS_PASSWORD_OTHER'] || 'password',
            :openstack_username     => ENV['OS_USERNAME_OTHER'] || 'demo',
            :openstack_domain_name  => ENV['OS_USER_DOMAIN_NAME'] || 'Default',
            :openstack_project_name => ENV['OS_PROJECT_NAME_OTHER'] || 'demo'
        )

        # delete transfer again
        transfer.destroy

        # check that transfer cannot be accepted when it has been deleted
        puts 'Checking that accepting a deleted transfer fails...' if ENV['DEBUG_VERBOSE']
        expect { other_service.transfers.accept(transfer_id, auth_key) }.to raise_error(Fog::Volume::OpenStack::NotFound)
      ensure
        # cleanup volume
        cleanup_test_object(@service.volumes, volume.id)
      end
    end
  end

  # TODO: tests for snapshots
  it 'responds to list_snapshots_detailed' do
    expect(@service.respond_to?(:list_snapshots_detailed)).to be true
  end


  # TODO: tests for quotas
 end
end