Shindo.tests('Fog::Compute::RackspaceV2 | image_tests', ['rackspace']) do

  pending if Fog.mocking?

  IMAGE_FORMAT = {
    'id' => String,
    'name' => String,
    'created' => Fog::Nullable::String,
    'updated' => Fog::Nullable::String,
    'status' => Fog::Nullable::String,
    'user_id' => Fog::Nullable::String,
    'tenant_id' => Fog::Nullable::String,
    'progress' => Fog::Nullable::Integer,
    'minDisk' => Fog::Nullable::Integer,
    'minRam' => Fog::Nullable::Integer,
    'metadata' => Fog::Nullable::Hash,
    'OS-DCF:diskConfig' => Fog::Nullable::String,
    'links' => [{
      'rel' => String,
      'href' => String,
      'type' => Fog::Nullable::String
    }]
  }

  LIST_IMAGE_FORMAT = {
    'images' => [IMAGE_FORMAT]
  }

  GET_IMAGE_FORMAT = {
    'image' => IMAGE_FORMAT
  }

  service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
  image_id = nil

  tests('success') do
    tests('#list_images').formats(LIST_IMAGE_FORMAT) do
      body = service.list_images.body
      image_id = body['images'][0]['id']
      body
    end

    tests('#get_image').formats(GET_IMAGE_FORMAT) do
      service.get_image(image_id).body
    end
  end
end
