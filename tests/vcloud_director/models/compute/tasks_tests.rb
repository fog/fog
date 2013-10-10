require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

Shindo.tests('Compute::VcloudDirector | tasks', ['vclouddirector']) do
  pending if Fog.mocking?

  tasks = organization.tasks
  pending if tasks.empty?
  task = tasks.first

  tests('Compute::VcloudDirector | task') do
    tests('#href').returns(String) { task.href.class }
    tests('#type').returns('application/vnd.vmware.vcloud.task+xml') { task.type }
    tests('#id').returns(String) { task.id.class }
    tests('#name').returns(String) { task.name.class }
    tests('#status').returns(String) { task.status.class }
    tests('#end_time').returns(Fog::Time) { task.end_time.class }
    tests('#expiry_time').returns(Fog::Time) { task.expiry_time.class }
    tests('#operation').returns(String) { task.operation.class }
    tests('#operation_name').returns(String) { task.operation_name.class }
  end

  tests('Compute::VcloudDirector | task', ['get']) do
    tests('#get_by_name').returns(task.name) { tasks.get_by_name(task.name).name }
    tests('#get').returns(task.id) { tasks.get(task.id).id }
  end
end
