Shindo.tests('Fog::Compute::DigitalOceanV2 | list_flavors request', ['digitalocean', 'compute']) do
  service = Fog::Compute.new(:provider => 'DigitalOcean', :version => 'V2')

  size_format = {
    'slug' => String,
    'memory' => Integer,
    'vcpus' => Integer,
    'disk' => Integer,
    'transfer' => Float,
    'price_monthly' => Float,
    'price_hourly' => Float,
    'regions' => Array,
    'available' => Fog::Boolean,
  }

  tests('success') do
    tests('#list_flavors') do
      service.list_flavors.body['sizes'].each do |size|
        tests('format').data_matches_schema(size_format) do
          size
        end
      end
    end
  end
end