Shindo.tests('Compute::VcloudDirector | session requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#post_login_sessions').data_matches_schema(VcloudDirector::Compute::Schema::SESSION_TYPE) do
    pending
    @service.login.body # calls post_login_sessions
  end

  tests('#get_current_session').data_matches_schema(VcloudDirector::Compute::Schema::SESSION_TYPE) do
    @service.get_current_session.body
  end

end
