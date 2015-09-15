Shindo.tests('Fog::Compute::DigitalOceanV2 | list_regions request', ['digitalocean', 'compute']) do
  service = Fog::Compute.new(:provider => 'DigitalOcean', :version => 'V2')

  region_format = {
    'slug' => String,
    'name' => String,
    'sizes' => Array,
    'available' => Fog::Boolean,
    'features' => Array,
  }

  tests('success') do
    tests('#list_regions') do
      service.list_regions.body['regions'].each do |region|
        tests('format').data_matches_schema(region_format) do
          region
        end
      end
    end
  end
end