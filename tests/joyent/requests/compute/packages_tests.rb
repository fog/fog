Shindo.tests("Fog::Compute[:joyent] | package requests", ["joyent"]) do
  @data = Fog::Compute[:joyent].data

  @package_format = {
    'name' => String,
    'vcpus' => Integer,
    'memory' => Integer,
    'disk' => Integer,
    'swap' => Integer,
    'default' => Fog::Boolean
  }

  if Fog.mock?
    @data[:packages] = {
      "regular_128" => {
        "name" => "regular_128",
        "memory" => 128,
        "disk" => 5120,
        "vcpus" => 1,
        "swap" => 256,
        "default" => true
      },
      "regular_256" => {
        "name" => "regular_256",
        "memory" => 256,
        "disk" => 5120,
        "vcpus" => 1,
        "swap" => 512,
        "default" => false
      },
      "regular_512" => {
        "name" => "regular_512",
        "memory" => 512,
        "disk" => 10240,
        "vcpus" => 1,
        "swap" => 1024,
        "default" => false
      }
    }
  end

  tests("#list_packages") do
    formats([@package_format]) do
      Fog::Compute[:joyent].list_packages.body
    end

    actual = @data[:packages].values.length
    returns(actual, "has correct number of packages") do
      Fog::Compute[:joyent].list_packages.body.length
    end
  end

  tests("#get_package") do
    pkgid = @data[:packages].keys.first

    formats(@package_format) do
      Fog::Compute[:joyent].get_package(pkgid).body
    end
  end
end
