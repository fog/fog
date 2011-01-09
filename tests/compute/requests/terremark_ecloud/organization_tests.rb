Shindo.tests('TerremarkEcloud::Compute | organization requests', ['terremark_ecloud']) do

  @organization_format = {
    'name' => String,
    'uri'  => String,
    'vdcs' => [{
                 'name' => String,
                 'uri'  => String
               }],
    'catalog_uri'   => String,
    'tasksList_uri' => String,
    'keysList_uri'  => String,
    'tagsList_uri'  => String
  }

  tests('success') do

    tests("#get_organization").formats(@organization_format) do
      TerremarkEcloud[:compute].get_organization.body
    end

  end

end
