Shindo.tests('Fog::Compute[:gce] | server requests', ['gce']) do

  @gce = Fog::Compute[:gce]

  @insert_server_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'user' => String,
      'startTime' => String,
      'insertTime' => String,
      'operationType' => String,
      'status' => String,
      'progress' => Integer
  }

  @get_server_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'image' => String,
      'machineType' => String,
      'status' => String,
      'zone' => String,
      'disks' => [],
      'networkInterfaces' => []
  }

  @delete_server_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'status' => String,
      'user' => String,
      'targetId' => String,
      'progress' => Integer,
      'insertTime' => String,
      'startTime' => String,
      'operationType' => String
  }

  @list_servers_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => []
  }

  tests('success') do

    server_name = 'new-server-test'

    tests("#insert_server").formats(@insert_server_format) do
      @gce.insert_server(server_name).body
    end

    tests("#get_server").formats(@get_server_format) do
      @gce.get_server(server_name).body
    end

    tests("#list_servers").formats(@list_servers_format) do
      @gce.list_servers.body
    end

    tests("#delete_server").formats(@delete_server_format) do
      @gce.delete_server(server_name).body
    end

  end

end
