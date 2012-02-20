Shindo.tests("Fog::Compute[:joyent] | dataset requests", ["joyent"]) do
  @dataset_format = {
    "description" => String,
    "requirements" => {},
    "name" => String,
    "version" => String,
    "os" => String,
    "id" => String,
    "urn" => String,
    "default" => Fog::Boolean,
    "type" => String,
    "created" => String
  }

  if Fog.mock?
    Fog::Compute[:joyent].data[:datasets] = {
      "7456f2b0-67ac-11e0-b5ec-832e6cf079d5" => {
        "name" => "nodejs",
        "version" => "1.1.3",
        "os" => "smartos",
        "id" => "7456f2b0-67ac-11e0-b5ec-832e6cf079d5",
        "urn" => "sdc:sdc:nodejs:1.1.3",
        "default" => true,
        "type" => "smartmachine",
        "created" => Time.parse("2011-04-15T22:04:12+00:00")
      },
      "febaa412-6417-11e0-bc56-535d219f2590" => {
        "name" => "smartos",
        "version" => "1.3.12",
        "os" => "smartos",
        "id" => "febaa412-6417-11e0-bc56-535d219f2590",
        "urn" => "sdc:sdc:smartos:1.3.23",
        "default" => false,
        "type" => "smartmachine",
        "created" => Time.parse("2011-04-11T08:45:00+00:00")
      }
    }
  end

  tests("#list_datasets") do
    formats(@dataset_format) do
      Fog::Compute[:joyent].list_datasets.body.first
    end
  end
end
