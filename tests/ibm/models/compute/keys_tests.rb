Shindo.tests('Fog::Compute[:ibm] | keys', ['ibm']) do

  tests('success') do

    @key_name = "fog test key"
    @key      = nil

    tests("Fog::Compute[:ibm].keys.create('#{@key_name}')") do
      @key = Fog::Compute[:ibm].keys.create(@key_name)
      returns(@key_name) { @key.name }
    end

    tests('Fog::Compute[:ibm].keys') do
      returns(true) { Fog::Compute[:ibm].keys.length > 0 }
    end

    tests("Fog::Compute[:ibm].keys.default = '#{@key_name}'") do
      returns(@key_name) { Fog::Compute[:ibm].keys.default = @key_name }
    end

    tests("Fog::Compute[:ibm].keys.default") do
      @key = Fog::Compute[:ibm].keys.get(@key_name)
      returns(@key.name) { Fog::Compute[:ibm].keys.default.name }
    end

    tests("Fog::Compute[:ibm].keys.get('#{@key_name}')") do
      key = Fog::Compute[:ibm].keys.get(@key_name)
      returns(@key_name) { key.name }
    end

    @key.destroy

  end

end
