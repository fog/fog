Shindo.tests('Compute::VcloudDirector | groups requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_groups_from_query').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
    pending if Fog.mocking?
    @service.get_groups_from_query.body
  end

end
