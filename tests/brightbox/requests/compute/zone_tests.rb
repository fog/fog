Shindo.tests('Fog::Compute[:brightbox] | zone requests', ['brightbox']) do

  tests('success') do

    tests("#list_zones") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_zones
      @zone_id = result.first["id"]
      formats(Brightbox::Compute::Formats::Collection::ZONES, false) { result }
    end

    tests("#get_zone('#{@zone_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_zone(@zone_id)
      formats(Brightbox::Compute::Formats::Full::ZONE, false) { result }
    end

  end

  tests('failure') do

    tests("#get_zone('zon-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_zone('zon-00000')
    end

    tests("#get_zone").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_zone
    end

  end

end
