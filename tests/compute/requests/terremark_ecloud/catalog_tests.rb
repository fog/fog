Shindo.tests('TerremarkEcloud::Compute | catalog requests', ['terremarkecloud']) do

  @catalog_format = {
    'name' => String,
    'href' => String,
    'CatalogItems' => [{
      'href'  => String,
      'name'  => String,
      'type'  => String
    }]
  }

  @catalog_item_format = {
    'name'      => String,
    'Entity'    => {
      'href' => String,
      'name' => String,
      'type' => String
    },
    'href'      => String,
    'Link'      => {
      'href' => String,
      'name' => String,
      'rel'  => String,
      'type' => String
    },
    'Property'  => {
      'LicensingCost' => String
    },
    'type'      => String,
  }

  tests('success') do

    tests("#get_catalog").formats(@catalog_format) do
      pending if Fog.mocking?
      TerremarkEcloud[:compute].get_catalog(TerremarkEcloud::Compute.preferred_catalog['href']).body
    end

    tests("#get_catalog_item").formats(@catalog_item_format) do
      pending if Fog.mocking?
      TerremarkEcloud[:compute].get_catalog_item(TerremarkEcloud::Compute.preferred_catalog_item['href']).body
    end

  end

end
