Shindo.tests('Fog::Compute[:brightbox] | database type requests', ['brightbox']) do

  tests('success') do
    tests("#list_database_types") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_database_types
      data_matches_schema(Brightbox::Compute::Formats::Collection::DATABASE_SERVER_TYPES, {:allow_extra_keys => true}) { result }
    end
  end

  tests('failure') do
    tests("#get_database_type").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_database_type("dbt-00000")
    end
  end
end
