Shindo.tests('Compute::VcloudDirector | task requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('error conditions') do
    tests('retrieve non-existent TasksList').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_task_list('00000000-0000-0000-0000-000000000000')
    end
    tests('retrieve non-existent Task').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_task('00000000-0000-0000-0000-000000000000')
    end
    tests('cancel non-existent Task').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.post_cancel_task('00000000-0000-0000-0000-000000000000')
    end
  end

  @org_id = VcloudDirector::Compute::Helper.current_org_id(@service)

  tests('#get_task_list').data_matches_schema(VcloudDirector::Compute::Schema::TASKS_LIST_TYPE) do
    session = @service.get_current_session.body
    org_href = session[:Link].find {|l| l[:type] == 'application/vnd.vmware.vcloud.org+xml'}[:href]
    @org_uuid = org_href.split('/').last
    @tasks_list = @service.get_task_list(@org_uuid).body
  end

  tests('each task in the task list') do
    @tasks_list[:Task].each do |task|
      task_id = task[:href].split('/').last
      tests("#get_task(#{task_id}").data_matches_schema(VcloudDirector::Compute::Schema::TASK_TYPE) do
        @service.get_task(task_id).body
      end
    end
  end

end
