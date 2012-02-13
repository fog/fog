Shindo.tests('Fog::Compute[:ibm] | key', ['ibm']) do

  tests('success') do

    @key_name = "fog test key"
    @key      = nil

    tests("Fog::Compute::IBM::Key.new('#{@key_name}')") do
      @key = Fog::Compute[:ibm].keys.new({:name => @key_name})
      returns(true) { @key.save }
    end

    tests("Fog::Compute::IBM::Key#instances") do
      returns([]) { @key.instances }
    end

    tests('Fog::Compute::IBM::Key#destroy') do
      returns(true) { @key.destroy }
    end

  end

end
