Shindo.tests('Compute::VcloudDirector | disk requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_disks_from_query').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
    pending if Fog.mocking?
    @service.get_disks_from_query.body
  end

  tests('Retrieve non-existent Disk').raises(Fog::Compute::VcloudDirector::Forbidden) do
    pending if Fog.mocking?
    @service.get_disk('00000000-0000-0000-0000-000000000000')
  end

end
