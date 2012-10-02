require 'fog/openstack'

Shindo.tests('Fog::Compute[:openstack] | image requests', ['openstack']) do

  @image_format = {
    'created'   => Fog::Nullable::String,
    'id'        => String,
    'name'      => String,
    'progress'  => Fog::Nullable::Integer,
    'status'    => String,
    'updated'   => String,
    'minRam'    => Integer,
    'minDisk'   => Integer,
    'server'    => Fog::Nullable::Hash,
    'metadata'  => Hash,
    'links'  => Array
  }

  tests('success') do
    # Setup
    @image_id = Fog::Compute[:openstack].images[0].id
    unless Fog.mocking?
      Fog::Compute[:openstack].images.get(@image_id).wait_for { ready? }
    end

    tests("#get_image_details(#{@image_id})").formats(@image_format) do
      pending if Fog.mocking?
      Fog::Compute[:openstack].get_image_details(@image_id).body['image']
    end

    tests('#list_images').formats({'images' => [OpenStack::Compute::Formats::SUMMARY]}) do
      Fog::Compute[:openstack].list_images.body
    end

    tests('#list_images_detail').formats({'images' => [@image_format]}) do
      Fog::Compute[:openstack].list_images_detail.body
    end

    # Teardown
    unless Fog.mocking?
      Fog::Compute[:openstack].images.get(@image_id).wait_for { ready? }
    end
  end

  tests('failure') do
    tests('#delete_image(0)').raises(Fog::Compute::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:openstack].delete_image(0)
    end

    tests('#get_image_details(0)').raises(Fog::Compute::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:openstack].get_image_details(0)
    end

  end

end
