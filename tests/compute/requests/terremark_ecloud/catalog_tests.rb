Shindo.tests('TerremarkEcloud::Compute | catalog requests', ['terremark_ecloud']) do

  @catalog_format = {
    'name' => String,
    'uri'  => String,
    'catalogItems' => [{
                         'name' => String,
                         'uri'  => String
                       }]
  }

  @catalog_item_format = {
    'name' => String,
    'uri'  => String,
    'customization_uri' => String,
    'template_uri' => String,
    'properties' => [{
                       'key' => String,
                       'value' => String
                     }]
  }

  tests('success') do

    tests("#get_catalog").formats(@catalog_format) do
      TerremarkEcloud[:compute].get_catalog(TerremarkEcloud::Compute.preferred_vdc['catalog_uri']).body
    end

    tests("#get_catalog_item").formats(@catalog_item_format) do
      TerremarkEcloud[:compute].get_catalog_item(TerremarkEcloud::Compute.preferred_catalog_item['uri']).body
    end

  end

end
