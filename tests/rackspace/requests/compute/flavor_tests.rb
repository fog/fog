Shindo.tests('Fog::Compute[:rackspace] | flavor requests', ['rackspace']) do

  @flavor_format = {
    'disk'  => Integer,
    'id'    => Integer,
    'name'  => String,
    'ram'   => Integer
  }

  @service = Fog::Compute.new(:provider => :rackspace, :version => :v1)

  tests('success') do
    tests('#get_flavor_details(1)').formats(@flavor_format) do
      pending if Fog.mocking?
       @service.get_flavor_details(1).body['flavor']
    end

    tests('#list_flavors').formats({'flavors' => [Rackspace::Compute::Formats::SUMMARY]}) do
      pending if Fog.mocking?
       @service.list_flavors.body
    end

    tests('#list_flavors_detail').formats({'flavors' => [@flavor_format]}) do
      pending if Fog.mocking?
       @service.list_flavors_detail.body
    end

  end

  tests('failure') do

    tests('#get_flavor_details(0)').raises(Fog::Compute::Rackspace::NotFound) do
      pending if Fog.mocking?
       @service.get_flavor_details(0)
    end

  end

end
