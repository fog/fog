require 'fog/openstack/image_v2'

if RUBY_VERSION =~ /1.8/
  require File.expand_path('../shared_context', __FILE__)
else
  require_relative './shared_context'
end

RSpec.describe Fog::Image::OpenStack do

  spec_data_folder = 'spec/fog/openstack/image_v2'

  include_context 'OpenStack specs with VCR'
  before :all do
    setup_vcr_and_service(
        :vcr_directory => spec_data_folder,
        # :service_class => Fog::Image::OpenStack::V2
        :service_class => Fog::Image::OpenStack # No need to be explicit - Fog will choose the latest available version
    )
  end

  def cleanup_image image, image_name=nil, image_id=nil
    # Delete the image
    image.destroy if image
    image_by_id = @service.images.find_by_id(image_id) rescue false if image_id
    image_by_id.destroy if image_by_id
    @service.images.all(:name => image_name).each do |image|
      image.destroy
    end if image_name
    # Check that the deletion worked
    expect { @service.images.find_by_id image_id }.to raise_error(Fog::Image::OpenStack::NotFound) if image_id
    expect(@service.images.all(:name => image_name).length).to be 0 if image_name
  end

  it "CRUD & list images" do
    VCR.use_cassette('image_v2_crud') do
      image_name = 'foobar'
      image_rename = 'baz'

      expect(@service.images.all).to_not be_nil
      begin
        # Create an image called foobar
        foobar_image = @service.images.create(:name => image_name)
        foobar_id = foobar_image.id
        expect(@service.images.all(:name => image_name).length).to be 1
        expect(foobar_image.status).to eq 'queued'

        # Rename it to baz
        foobar_image.update(:name => image_rename) # see "Patch images" test below - for now this will be a simple synthesis of a JSON patch with op = 'replace'
        expect(foobar_image.name).to eq image_rename
        baz_image = @service.images.find_by_id foobar_id
        expect(baz_image).to_not be_nil
        expect(baz_image.id).to eq foobar_id
        expect(baz_image.name).to eq image_rename

        # Read the image freshly by listing images filtered by the new name
        images = @service.images.all(:name => image_rename)
        expect(images.length).to be 1
        expect(images.first.id).to eq baz_image.id

      ensure
        cleanup_image baz_image
        @service.images.all.select { |image| [image_name, image_rename].include? image.name }.each do |image|
          image.destroy
        end
        # Check that the deletion worked
        expect(@service.images.all.select { |image| [image_name, image_rename].include? image.name }.length).to be 0
      end
    end
  end

  it "Image creation with ID" do
    VCR.use_cassette('image_v2_create_id') do
      image_name = 'foobar_id'

      # Here be dragons - highly recommend not to supply an ID when creating
      begin
        # increment this identifier when running test more than once, unless the VCR recording is being used
        identifier = '11111111-2222-3333-aaaa-bbbbbbccccdf'

        # Create an image with a specified ID
        foobar_image = @service.images.create(:name => 'foobar_id', :id => identifier)
        foobar_id = foobar_image.id
        expect(@service.images.all(:name => image_name).length).to be 1
        expect(foobar_image.status).to eq 'queued'
        expect(foobar_id).to eq identifier

        get_image = @service.images.find_by_id(identifier)
        expect(get_image.name).to eq image_name

      ensure
        cleanup_image foobar_image, image_name, foobar_id
      end
    end
  end

  it "Image creation with specified location" do
    VCR.use_cassette('image_v2_create_location') do

      begin
        # Create image with location of image data
        pending "Figure out 'Create image with location of image data'"
        fail

      ensure
      end
    end
  end

  it "Image upload & download in bulk" do
    VCR.use_cassette('image_v2_upload_download') do
      image_name = 'foobar_up1'
      begin
        image_path = "#{spec_data_folder}/minimal.ova" # "no-op" virtual machine image, 80kB .ova file containing 64Mb dynamic disk

        foobar_image = @service.images.create(:name => image_name,
                                              :container_format => 'ovf',
                                              :disk_format => 'vmdk'
        )
        foobar_id = foobar_image.id

        # Upload data from File or IO object
        foobar_image.upload_data File.new(image_path, 'r')

        # Status should be saving or active
        expect(@service.images.find_by_id(foobar_id).status).to satisfy { |value| ['saving', 'active'].include? value }

        # Get an IO object from which to download image data - wait until finished saving though
        while @service.images.find_by_id(foobar_id).status == 'saving' do
          sleep 1
        end
        expect(@service.images.find_by_id(foobar_id).status).to eq 'active'

        # Bulk download
        downloaded_data = foobar_image.download_data
        expect(downloaded_data.size).to eq File.size(image_path)

      ensure
        cleanup_image foobar_image, image_name
      end
    end
  end

  it "Deactivates and activates an image" do
    VCR.use_cassette('image_v2_activation') do
      image_name = 'foobar3a'
      image_path = "spec/fog/openstack/image_v2/minimal.ova" # "no-op" virtual machine image, 80kB .ova file containing 64Mb dynamic disk

      begin
        # Create an image called foobar2
        foobar_image = @service.images.create(:name => image_name,
                                              :container_format => 'ovf',
                                              :disk_format => 'vmdk'
        )
        foobar_id = foobar_image.id
        foobar_image.upload_data File.new(image_path, 'r')
        while @service.images.find_by_id(foobar_id).status == 'saving' do
          sleep 1
        end

        foobar_image.deactivate
        expect { foobar_image.download_data }.to raise_error(Excon::Errors::Forbidden)

        foobar_image.reactivate
        expect { foobar_image.download_data }.not_to raise_error
      ensure
        cleanup_image foobar_image, image_name
      end
    end
  end

  it "Adds and deletes image tags" do
    VCR.use_cassette('image_v2_tags') do
      image_name = 'foobar3'
      begin
        # Create an image
        foobar_image = @service.images.create(:name => image_name,
                                              :container_format => 'ovf',
                                              :disk_format => 'vmdk'
        )
        foobar_id = foobar_image.id

        foobar_image.add_tag 'tag1'
        expect(@service.images.find_by_id(foobar_id).tags).to contain_exactly('tag1')

        foobar_image.add_tags ['tag2', 'tag3', 'tag4']
        expect(@service.images.find_by_id(foobar_id).tags).to contain_exactly('tag1', 'tag2', 'tag3', 'tag4')

        foobar_image.remove_tag 'tag2'
        expect(@service.images.find_by_id(foobar_id).tags).to contain_exactly('tag1', 'tag3', 'tag4')

        foobar_image.remove_tags ['tag1', 'tag3']
        expect(@service.images.find_by_id(foobar_id).tags).to contain_exactly('tag4')

      ensure
        cleanup_image foobar_image, image_name
      end
    end
  end

  it "CRUD and list image members" do
    VCR.use_cassette('image_v2_member_crudl') do
      image_name = 'foobar4'
      tenant_id = 'tenant1'
      begin
        # Create an image called foobar
        foobar_image = @service.images.create(:name => image_name)
        foobar_id = foobar_image.id

        expect(foobar_image.members.size).to be 0
        foobar_image.add_member tenant_id
        expect(foobar_image.members.size).to be 1

        member = foobar_image.member tenant_id
        expect(member).to_not be_nil
        expect(member['status']).to eq 'pending'

        member['status'] = 'accepted'
        foobar_image.update_member member
        expect(foobar_image.member(tenant_id)['status']).to eq 'accepted'

        foobar_image.remove_member member['member_id']
        expect(foobar_image.members.size).to be 0
      ensure
        cleanup_image foobar_image, image_name
      end
    end
  end

  it "Gets JSON schemas for 'images', 'image', 'members', 'member'" do
    VCR.use_cassette('image_v2_schemas') do
      pending 'Fetching JSON schemas: to be implemented'
      fail
    end
  end

  it "CRUD resource types" do
    VCR.use_cassette('image_v2_resource_type_crud') do
      pending 'CRUD resource types: to be implemented'
      fail
    end
  end

  it "CRUD namespace metadata definition" do
    VCR.use_cassette('image_v2_namespace_metadata_crud') do
      pending 'CRUD namespace metadata definition: to be implemented'
      fail
    end
  end

  it "CRUD property metadata definition" do
    VCR.use_cassette('image_v2_property_metadata_crud') do
      pending 'CRUD property metadata definition: to be implemented'
      fail
    end
  end

  it "CRUD object metadata definition" do
    VCR.use_cassette('image_v2_object_metadata_crud') do
      pending 'CRUD object metadata definition: to be implemented'
      fail
    end
  end

  it "CRUD tag metadata definition" do
    VCR.use_cassette('image_v2_tag_metadata_crud') do
      pending 'CRUD tag metadata definition: to be implemented'
      fail
    end
  end

  it "CRUD schema metadata definition" do
    VCR.use_cassette('image_v2_schema_metadata_crud') do
      pending 'CRUD schema metadata definition: to be implemented'
      fail
    end
  end

  it "Creates, lists & gets tasks" do
    VCR.use_cassette('image_v2_task_clg') do
      pending 'Creates, lists & gets tasks: to be implemented'
      fail
    end
  end
end