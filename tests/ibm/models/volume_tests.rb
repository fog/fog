Shindo.tests('Fog::Compute[:ibm] | volume', ['ibm']) do

  tests('success') do
    
    @volume       = nil
    @volume_id    = nil
    @name         = "fog test volume" 
    @format       = "raw"
    @location_id  = "101"
    @size         = "256"
    @offering_id  = "20001208"
        
    tests('Fog::Compute::IBM::Volume.new') do
      @volume = Fog::Compute[:ibm].volumes.new(
        :name           => @name,
        :format         => @image_id,
        :location_id    => @location_id,
        :size           => @size,
        :offering_id    => @offering_id
      )
      returns(@name) { @volume.name }
    end
    
    tests('Fog::Compute::IBM::Volume#save') do
      returns(true)   { @volume.save }
      returns(String) { @volume.id.class }
      @volume_id = @volume.id
    end
    
    tests("Fog::Compute::IBM::Volume#instance") do
      returns(nil) { @volume.instance }
    end

    tests("Fog::Compute::IBM::Volume#location") do
      returns(Fog::Compute::IBM::Location) { @volume.location.class }
    end
    
    tests('Fog::Compute::IBM::Volume#id') do
      returns(@volume_id) { @volume.id }
    end

    tests('Fog::Compute::IBM::Volume#ready?') do
      # We do a "get" to advance the state if we are mocked.
      # TODO: Fix this for real connections
      Fog::Compute[:ibm].get_volume(@volume_id)
      returns(true) { @volume.ready? }
    end

    tests('Fog::Compute::IBM::Volume#status') do
      returns("Detached") { @volume.status }
    end

    tests('Fog::Compute::IBM::Volume#destroy') do
      returns(true) { @volume.destroy }
    end
    
  end
  
end