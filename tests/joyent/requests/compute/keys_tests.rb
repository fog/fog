Shindo.tests("Fog::Compute[:joyent] | key requests", ['joyent']) do

  @key_format = {
    "name" => String,
    "key" => String,
    "created" => Time,
    "updated" => Time
  }

  before do
    #
    # Clear out all the test keys on the account in prep for test
    #
    Fog::Compute[:joyent].list_keys.body.each do |key|
      if key["name"] =~ /^fog-test/
        Fog::Compute[:joyent].delete_key(key["name"])
      end
    end

    @test_key_name = "fog-test-#{Time.now.utc.to_i}"

    Fog::Compute[:joyent].create_key(
      :name => @test_key_name,
      :key => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWxSNYngOTeu0pYd+2tpfYGISuMfMUNGyAIh4yRprAbacVddRq4Nyr12vDklzaRTzgd9PgX/82JMb4RARbVTtUKXJXmaBLvg2epGM+ScanZIitzL53whJrlGx+7nT+TnRdkB1XG7uIf2EpTQBaKrT4iG0magCXh5bmOqCyWte2gV8fArMg5bZclUT1p2E7qEW0htaLOiMSyGkjBlxb6vYQCA/Pa8VWETHehIF46S942gCj0aaL81gTocfyTm5/F+AgvUAsjHzRVkB/Dlhwq7Q7sK+4iAhlKPYMflkKC8r+nF0/LL9S3lllLZvbkEWJfEqlMCAbgmjTpYlBzQEqf/eN"
    )
  end

  tests("#list_keys").formats(@key_format) do
    Fog::Compute[:joyent].list_keys.body.first
  end

  tests("#get_key").formats(@key_format) do
    Fog::Compute[:joyent].get_key(@test_key_name).body
  end

  tests("#delete_key") do
    returns(204 , "returns status code 204") do
      Fog::Compute[:joyent].delete_key(@test_key_name).status
    end

    raises(Excon::Errors::NotFound, "when a key no longer exists") do
      Fog::Compute[:joyent].delete_key(@test_key_name)
      Fog::Compute[:joyent].delete_key(@test_key_name)
    end
  end

end
