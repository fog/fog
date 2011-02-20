Shindo.tests('TerremarkEcloud::Compute | organization requests', ['terremarkecloud']) do

  @organization_format = {
    'name'  => String,
    'href'  => String,
    'Link'  => [{
      'href'  => String,
      'name'  => String,
      'rel'   => String,
      'type'  => String
    }],
  }

  tests('success') do

    tests("#login (get_organizations)").formats({'OrgList' => [{'href' => String, 'name' => String, 'type' => String}]}) do
      pending if Fog.mocking?
      TerremarkEcloud[:compute].login.body
    end

    tests("#get_organization").formats(@organization_format) do
      pending if Fog.mocking?
      TerremarkEcloud[:compute].get_organization.body
    end

  end

end
