Shindo.tests('Fog::Compute[:ibm] | locations', ['ibm']) do

  tests('success') do

    @location_id = '41'

    tests('Fog::Compute[:ibm].locations') do
      returns(true) { Fog::Compute[:ibm].locations.length > 0 }
    end

    tests('Fog::Compute[:ibm].locations.get("#{@location_id}")') do
      @location = Fog::Compute[:ibm].locations.get(@location_id)
      returns(@location_id) { @location.id }
    end

  end

end
