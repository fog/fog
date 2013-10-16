Shindo.tests('Compute::VcloudDirector | task requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_task_list').data_matches_schema(VcloudDirector::Compute::Schema::TASKS_LIST_TYPE) do
    session = @service.get_current_session.body
    org_href = session[:Link].detect {|l| l[:type] == 'application/vnd.vmware.vcloud.org+xml'}[:href]
    @org_uuid = org_href.split('/').last
    @tasks_list = @service.get_task_list(@org_uuid).body
  end

  tests('retrieve non-existent TasksList').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.get_task_list('00000000-0000-0000-0000-000000000000')
  end

  tests('retrieve non-existent Task').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.get_task('00000000-0000-0000-0000-000000000000')
  end

end
