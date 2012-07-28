Shindo.tests("Fog::Compute[:joyent] | dataset requests", ["joyent"]) do
  @dataset_format = {
    "description" => String,
    "requirements" => {
      "max_memory" => Integer,
      "min_memory" => Integer
    },
    "name" => String,
    "version" => String,
    "os" => String,
    "id" => String,
    "urn" => String,
    "default" => Fog::Boolean,
    "type" => String,
    "created" => Time,
  }

  if Fog.mock?
    Fog::Compute[:joyent].data[:datasets] = {
      "33904834-1f01-49d3-bed3-b642e158c375" => {
        "id" => "33904834-1f01-49d3-bed3-b642e158c375",
        "urn" => "sdc:sdc:zeus-simple-lb-200mbps:1.1.1",
        "name" => "zeus-simple-lb-200mbps",
        "os" => "smartos",
        "type" => "smartmachine",
        "description" => "Zeus Simple Load Balancer 200 Mbps SmartMachine",
        "default" => false,
        "requirements" => {
          "max_memory" => 32768,
          "min_memory" => 4096
        },
        "version" => "1.1.1",
        "created" => Time.parse("2011-09-15T07:39:13+00:00")
      },
      "3fcf35d2-dd79-11e0-bdcd-b3c7ac8aeea6" => {
        "id" => "3fcf35d2-dd79-11e0-bdcd-b3c7ac8aeea6",
        "urn" => "sdc:sdc:mysql:1.4.1",
        "name" => "mysql",
        "os" => "smartos",
        "type" => "smartmachine",
        "description" => "MySQL SmartMachine",
        "default" => false,
        "requirements" => {
          "max_memory" => 32768,
          "min_memory" => 4096
        },
        "version" => "1.4.1",
        "created" => Time.parse("2011-09-15T05:01:34+00:00")
      }
    }
  end

  tests("#list_datasets") do
    formats(@dataset_format) do
      Fog::Compute[:joyent].list_datasets.body.first
    end
  end
end
