Shindo.tests('Fog::Compute[:digitalocean] | list_flavors request', ['digitalocean', 'compute']) do

  # {"id":2,"name":"Amsterdam 1"}
  @flavor_format = {
    'id'           => Integer,
    'name'         => String,
  }

  tests('success') do

    tests('#list_flavor') do
      flavors = Fog::Compute[:digitalocean].list_flavors.body
      test 'returns a Hash' do
        flavors.is_a? Hash
      end
      tests('flavor').formats(@flavor_format, false) do
        flavors['sizes'].first
      end
    end

  end

end
