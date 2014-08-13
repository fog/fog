Shindo.tests('Fog::Google[:sql] | operation requests', ['google']) do
  @sql = Fog::Google[:sql]
  @instance_id = Fog::Mock.random_letters(16)
  @instance = @sql.instances.create(:instance => @instance_id, :tier => 'D1')
  @instance.wait_for { ready? }

  @get_operation_format = {
    'operation' => String,
    'endTime' => Fog::Nullable::String,
    'enqueuedTime' => String,
    'error' => Fog::Nullable::Array,
    'exportContext' => Fog::Nullable::Array,
    'importContext' => Fog::Nullable::Array,
    'instance' => String,
    'kind' => String,
    'operationType' => String,
    'startTime' => Fog::Nullable::String,
    'state' => String,
    'userEmailAddress' => String,
  }

  @list_operations_format = {
    'kind' => String,
    'items' => [@get_operation_format],
  }

  tests('success') do

    tests('#list_operations').formats(@list_operations_format) do
      @sql.list_operations(@instance_id).body
    end

    tests('#get_operation').formats(@get_operation_format) do
      operation_id = @sql.operations.all(@instance_id).first.operation
      @sql.get_operation(@instance_id, operation_id).body
    end

  end

  @instance.destroy

end
