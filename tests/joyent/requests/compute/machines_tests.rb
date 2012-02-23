Shindo.tests("Fog::Compute[:joyent] | machine requests", ["joyent"]) do

  @machine_format = {
    "id" => String,
    "name" => String,
    "type" => String,
    "state" => String,
    "dataset" => String,
    "memory" => Integer,
    "disk" => Integer,
    "ips" => Array,
    "metadata" => Hash,
    "created" => Time,
    "updated" => Time
  }

  if Fog.mock?
    @machines = Fog::Compute[:joyent].data[:machines] = {
      "15080eca-3786-4bb8-a4d0-f43e1981cd72" => {
        "id" => "15080eca-3786-4bb8-a4d0-f43e1981cd72",
        "name" => "getting-started",
        "type" => "smartmachine",
        "state" => "running",
        "dataset" => "sdc:sdc:smartos:1.3.15",
        "memory" => 256,
        "disk" => 5120,
        "ips" => ["10.88.88.50"],
        "metadata" => {},
        "created" => Time.parse("2011-06-03T00:02:31+00:00"),
        "updated" => Time.parse("2011-06-03T00:02:31+00:00")
      }
    }
  end

  @provider = Fog::Compute[:joyent]


  #
  # https://us-west-1.api.joyentcloud.com/docs#ListMachines
  #
  tests("#list_machines") do
    if Fog.mock?
      returns(@machines.length, "correct number of machines") do
        @provider.list_machines.body.length
      end
    end

    returns(Array, "returns an Array of machines") do
      @provider.list_machines.body.class
    end

    formats([@machine_format]) do
      @provider.list_machines.body
    end
  end

  # https://us-west-1.api.joyentcloud.com/docs#GetMachine
  tests("#get_machine") do
    machines = @provider.list_machines.body
    unless machines.empty?
      formats(@machine_format) do
        id = machines.first["id"]
        @provider.get_machine(id).body
      end
    end
  end
end
