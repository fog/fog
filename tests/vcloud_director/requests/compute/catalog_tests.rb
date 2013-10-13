Shindo.tests('Compute::VcloudDirector | catalog requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('#get_catalog').data_matches_schema(VcloudDirector::Compute::Schema::CATALOG_TYPE) do
    link = @org[:Link].detect do |l|
      l[:rel] == 'down' && l[:type] == 'application/vnd.vmware.vcloud.catalog+xml'
    end
    @catalog_id = link[:href].split('/').last
    pending if Fog.mocking?
    @catalog = @service.get_catalog(@catalog_id).body
  end

  tests('#get_catalog_metadata').data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
    pending if Fog.mocking?
    @service.get_catalog_metadata(@catalog_id).body
  end

  tests('#get_control_access_params_catalog').data_matches_schema(VcloudDirector::Compute::Schema::CONTROL_ACCESS_PARAMS_TYPE) do
    pending if Fog.mocking?
    @service.get_control_access_params_catalog(@org[:href].split('/').last, @catalog_id).body
  end

  tests('#get_catalogs_from_query').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
    pending if Fog.mocking?
    @service.get_catalogs_from_query.body
  end

  tests('Retrieve non-existent Catalog').raises(Excon::Errors::Forbidden) do
    pending if Fog.mocking?
    @service.get_catalog('00000000-0000-0000-0000-000000000000')
  end

end
