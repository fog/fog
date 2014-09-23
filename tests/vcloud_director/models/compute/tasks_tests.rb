require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests('Compute::VcloudDirector | tasks', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new()

  if Fog.mocking?
    # add a bunch of tasks
    50.times do
      task_id = @service.enqueue_task(
        "Bogus Task",
        'BogusTaskName',
        {
          :href => 'https://example.com/api/bogus/12345678-1234-1234-1234-123456789012',
          :name => 'Bogus object',
          :type => 'application/vnd.vmware.vcloud.bogus+xml'
        }
      )
    end
  end

  tasks = organization.tasks
  pending if tasks.empty?
  task = tasks.first

  tests('Compute::VcloudDirector | task') do
    tests('#href').returns(String) { task.href.class }
    tests('#type').returns('application/vnd.vmware.vcloud.task+xml') { task.type }
    tests('#id').returns(String) { task.id.class }
    tests('#name').returns(String) { task.name.class }
    tests('#status').returns(String) { task.status.class }
    tests('#end_time').returns(Time) { task.end_time.class }
    tests('#expiry_time').returns(Time) { task.expiry_time.class }
    tests('#operation').returns(String) { task.operation.class }
    tests('#operation_name').returns(String) { task.operation_name.class }
  end

  tests('Compute::VcloudDirector | task', ['get']) do
    tests('#get_by_name').returns(task.name) { tasks.get_by_name(task.name).name }
    tests('#get').returns(task.id) { tasks.get(task.id).id }
  end

  # We should also be able to find tasks via the Query API
  # NB:  Query name == task.operation_name
  tests("Compute::VcloudDirector | tasks", ['find_by_query']) do
    tests('we can retrieve :name without lazy loading').returns(task.operation_name) do
      query_task = tasks.find_by_query(:filter => "name==#{task.operation_name}").first
      query_task.attributes[:name]
    end
    tests('by name').returns(task.operation_name) do
      query_task = tasks.find_by_query(:filter => "name==#{task.operation_name}").first
      query_task.name
    end
  end

end
