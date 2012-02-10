Shindo.tests("Fog::Compute::Joyent | key requests", ['joyent']) do

  @key_format = {
    "name" => String,
    "key" => String,
    "created" => Time
  }

  before do
    Fog::Compute[:joyent].create_key(
      :name => "key1",
      :key => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAlau1...")

    Fog::Compute[:joyent].create_key(
      :name => "key2",
      :key => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAlau1...")
  end

  tests("#list_keys").formats([@key_format]) do
    Fog::Compute[:joyent].list_keys.body
  end

  tests("#list_keys") do
    returns(2) do
      Fog::Compute[:joyent].list_keys.body.length
    end
  end

  tests("#get_key").formats(@key_format) do
    Fog::Compute[:joyent].get_key('key1').body
  end

  tests("#get_key").formats(@key_format) do
    Fog::Compute[:joyent].get_key('key2').body
  end

  tests("#delete_key") do
    returns(200, "returns status code 200") do
      Fog::Compute[:joyent].delete_key("key1").status
    end

    raises(Excon::Errors::NotFound, "when a key no longer exists") do
      Fog::Compute[:joyent].delete_key("key1")
      Fog::Compute[:joyent].delete_key("key1")
    end
  end

end
