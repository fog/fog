Shindo.tests('Fog::Storage[:ibm] | volume', ['ibm']) do

  tests('success') do

    @volume       = nil
    @volume_id    = nil
    @name         = "fog test volume"
    @format       = "RAW"
    @location_id  = "41"
    @size         = "256"
    @offering_id  = "20001208"

    tests('Fog::Storage::IBM::Volume.new') do
      @volume = Fog::Storage[:ibm].volumes.new(
        :name           => @name,
        :format         => @format,
        :location_id    => @location_id,
        :size           => @size,
        :offering_id    => @offering_id
      )
      returns(@name) { @volume.name }
    end

    tests('Fog::Storage::IBM::Volume#save') do
      returns(true)   { @volume.save }
      returns(String) { @volume.id.class }
      @volume_id = @volume.id
    end

    tests("Fog::Storage::IBM::Volume#instance") do
      returns(nil) { @volume.instance }
    end

    tests("Fog::Storage::IBM::Volume#location") do
      returns(Fog::Compute::IBM::Location) { @volume.location.class }
    end

    tests('Fog::Storage::IBM::Volume#id') do
      returns(@volume_id) { @volume.id }
    end

    tests('Fog::Storage::IBM::Volume#ready?') do
      # We do a "get" to advance the state if we are mocked.
      # TODO: Fix this for real connections
      Fog::Storage[:ibm].get_volume(@volume_id)
      returns(true) { @volume.ready? }
    end

    tests('Fog::Storage::IBM::Volume#status') do
      returns("Detached") { @volume.status }
    end

    tests('Fog::Storage::IBM::Volume#destroy') do
      returns(true) { @volume.destroy }
    end

  end

end
