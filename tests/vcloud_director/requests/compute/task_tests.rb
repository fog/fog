Shindo.tests('Compute::VcloudDirector | task requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('get current organization') do
    session = @service.get_current_session.body
    org_href = session[:Link].detect {|l| l[:type] == 'application/vnd.vmware.vcloud.org+xml'}[:href]
    @org_uuid = org_href.split('/').last
  end

  tests('#get_tasks_list').data_matches_schema(VcloudDirector::Compute::Schema::TASKS_LIST_TYPE) do
    @tasks_list = @service.get_tasks_list(@org_uuid).body
  end

  tests('retrieve non-existent TasksList').raises(Excon::Errors::Forbidden) do
    @service.get_tasks_list('00000000-0000-0000-0000-000000000000')
  end

end
