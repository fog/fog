Shindo.tests('Compute::VcloudDirector | users requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_users_from_query').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
    pending if Fog.mocking?
    @service.get_users_from_query.body
  end

end
