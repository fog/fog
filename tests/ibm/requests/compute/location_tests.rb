Shindo.tests('Fog::Compute[:ibm] | location requests', ['ibm']) do

  @location_format  = {
    'state'         => Integer,
    'location'      => String,
    'capabilities'  => Array,
    'name'          => String,
    'id'            => String,
    'description'   => String
  }

  @locations_format = {
    'locations'     => [ @location_format ]
  }

  tests('success') do

    tests("#list_locations").formats(@locations_format) do
      Fog::Compute[:ibm].list_locations.body
    end

    tests('#get_locations').formats(@location_format) do
      Fog::Compute[:ibm].get_location('41').body
    end

  end

end
