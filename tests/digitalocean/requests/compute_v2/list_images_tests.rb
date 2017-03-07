Shindo.tests('Fog::Compute::DigitalOceanV2 | list_images request', ['digitalocean', 'compute']) do
  service = Fog::Compute.new(:provider => 'DigitalOcean', :version => 'V2')

  image_format = {
    'id' => Integer,
    'name' => String,
    'type' => String,
    'distribution' => String,
    'slug' => Fog::Nullable::String,
    'public' => Fog::Boolean,
    'regions' => Array,
    'min_disk_size' => Fog::Nullable::Integer,
    'created_at' => String,
  }

  tests('success') do
    tests('#list_images') do
      service.list_images.body['images'].each do |image|
        tests('format').data_matches_schema(image_format) do
          image
        end
      end
    end
  end
end
