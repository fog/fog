Shindo.tests("Fog::Compute[:azure] | servers request", ["azure", "compute"]) do

  tests("#servers") do
    servers = Fog::Compute[:azure].servers
    servers = [fog_server] if servers.empty?

    test "returns a Array" do
      servers.is_a? Array
    end

    test("should return valid server name") do
      servers.first.name.is_a? String
    end

    test("should return records") do
      servers.size >= 1
    end
  end

end
