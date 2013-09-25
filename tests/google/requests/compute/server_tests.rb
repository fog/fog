Shindo.tests('Fog::Compute[:google] | server requests', ['google']) do

  @google = Fog::Compute[:google]

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
  }

  tests('success') do

    server_name = 'new-server-test'
    image_name = "gcel-12-04-v20130325"
    machine_type = "n1-standard-1"
    zone_name = "us-central1-a"

    tests("#insert_server").formats(@insert_server_format) do
      @google.insert_server(
        server_name,
        image_name,
        zone_name,
        machine_type
      ).body
    end

    tests("#list_servers").formats(@list_servers_format) do
      @google.list_servers(zone_name).body
    end

    # Both of these tests require the server to be there...

    #tests("#get_server").formats(@get_server_format) do
    #  @google.get_server(server_name, zone_name).body
    #end

    #tests("#delete_server").formats(@delete_server_format) do
    #  @google.delete_server(server_name, zone_name).body
    #end
  end
end
