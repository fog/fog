Shindo.tests('Brightbox::Compute | zone requests', ['brightbox']) do

  tests('success') do

    tests("#list_zones()").formats(Brightbox::Compute::Formats::Collection::ZONES) do
      data = Brightbox[:compute].list_zones()
      @zone_id = data.first["id"]
      data
    end

    tests("#get_zone('#{@zone_id}')").formats(Brightbox::Compute::Formats::Full::ZONE) do
      Brightbox[:compute].get_zone(@zone_id)
    end

  end

  tests('failure') do

    tests("#get_zone('zon-00000')").raises(Excon::Errors::NotFound) do
      Brightbox[:compute].get_zone('zon-00000')
    end

    tests("#get_zone()").raises(ArgumentError) do
      Brightbox[:compute].get_zone()
    end
  end

end
