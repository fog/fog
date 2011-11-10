Shindo.tests('Fog::Compute[:brightbox] | zone requests', ['brightbox']) do

  tests('success') do

    tests("#list_zones").formats(Brightbox::Compute::Formats::Collection::ZONES) do
      pending if Fog.mocking?
      data = Fog::Compute[:brightbox].list_zones
      @zone_id = data.first["id"]
      data
    end

    tests("#get_zone('#{@zone_id}')").formats(Brightbox::Compute::Formats::Full::ZONE) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_zone(@zone_id)
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
