Shindo.tests('Fog::Compute[:bluebox] | location requests', ['bluebox']) do

  @location_format = {
    'id'          => String,
    'description' => String
  }

  tests('success') do

    @location_id  = compute_providers[:bluebox][:server_attributes][:location_id]

    tests("get_location('#{@location_id}')").formats(@location_format) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_location(@location_id).body
    end

    tests("get_locations").formats([@location_format]) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_locations.body
    end

  end

  tests('failure') do

    tests("get_location('00000000-0000-0000-0000-000000000000')").raises(Fog::Compute::Bluebox::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:bluebox].get_location('00000000-0000-0000-0000-000000000000')
    end

  end
end
