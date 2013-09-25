Shindo.tests('Fog::Compute[:digitalocean] | list_regions request', ['digitalocean', 'compute']) do

  # {"id":2,"name":"Amsterdam 1"}
  @region_format = {
    'id'           => Integer,
    'name'         => String,
  }

  tests('success') do

    tests('#list_regions') do
      regions = Fog::Compute[:digitalocean].list_regions.body
      test 'returns a Hash' do
        regions.is_a? Hash
      end
      tests('region').formats(@region_format, false) do
        regions['regions'].first
      end
    end

  end

end
