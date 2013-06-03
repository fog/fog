Shindo.tests("Fog::Compute[:joyent] | network requests", ["joyent"]) do
  @provider = Fog::Compute[:joyent]
  @network_format = {
    "id" => String,
    "name" => String,
    "public" => Fog::Boolean
  }

  if Fog.mock?
    @networks = Fog::Compute[:joyent].data[:networks] = {
      "193d6804-256c-4e89-a4cd-46f045959993" => {
        "id" => "193d6804-256c-4e89-a4cd-46f045959993",
        "name" => "Joyent-SDC-Private",
        "public" => false
      },
      "1e7bb0e1-25a9-43b6-bb19-f79ae9540b39" => {
        "id" => "1e7bb0e1-25a9-43b6-bb19-f79ae9540b39",
        "name" => "Joyent-SDC-Public",
        "public" => true
      }
    }
  end

  tests("#list_networks") do
    if Fog.mock?
      returns(@networks.length, "correct number of networks") do
        @provider.list_networks.body.length
      end
    end

    returns(Array, "returns an Array of networks") do
      @provider.list_networks.body.class
    end

    formats([@network_format]) do
      @provider.list_networks.body
    end
  end
end
