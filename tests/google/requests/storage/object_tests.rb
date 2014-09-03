require 'securerandom'

Shindo.tests('Fog::Storage[:google] | object requests', ["google"]) do

  random_string = SecureRandom.hex
  @directory = Fog::Storage[:google].directories.create(:key => "fog-test-object-#{random_string}")

  tests('success') do

    tests("#put_object('#{@directory.identity}', 'fog_object', lorem_file)").succeeds do
      Fog::Storage[:google].put_object(@directory.identity, 'fog_object', lorem_file)
    end

    tests("#copy_object('#{@directory.identity}', 'fog_object', '#{@directory.identity}', 'fog_other_object')").succeeds do
      Fog::Storage[:google].copy_object(@directory.identity, 'fog_object', @directory.identity, 'fog_other_object')
    end

    Fog::Storage[:google].delete_object(@directory.identity, 'fog_other_object')

    tests("#get_object('#{@directory.identity}', 'fog_object')").returns(lorem_file.read) do
      Fog::Storage[:google].get_object(@directory.identity, 'fog_object').body
    end

    tests("#get_object('#{@directory.identity}', 'fog_object', &block)").returns(lorem_file.read) do
      data = ''
      Fog::Storage[:google].get_object(@directory.identity, 'fog_object') do |chunk, remaining_bytes, total_bytes|
        data << chunk
      end
      data
    end

    tests("#head_object('#{@directory.identity}', 'fog_object')").succeeds do
      Fog::Storage[:google].head_object(@directory.identity, 'fog_object')
    end

    tests("#delete_object('#{@directory.identity}', 'fog_object')").succeeds do
      Fog::Storage[:google].delete_object(@directory.identity, 'fog_object')
    end

  end

  tests('failure') do

    tests("#put_object('fognonbucket', 'fog_non_object', lorem_file)").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].put_object('fognonbucket', 'fog_non_object', lorem_file)
    end

    tests("#copy_object('fognonbucket', 'fog_object', '#{@directory.identity}', 'fog_other_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].copy_object('fognonbucket', 'fog_object', @directory.identity, 'fog_other_object')
    end

    tests("#copy_object('#{@directory.identity}', 'fog_non_object', '#{@directory.identity}', 'fog_other_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].copy_object(@directory.identity, 'fog_non_object', @directory.identity, 'fog_other_object')
    end

    tests("#copy_object('#{@directory.identity}', 'fog_object', 'fognonbucket', 'fog_other_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].copy_object(@directory.identity, 'fog_object', 'fognonbucket', 'fog_other_object')
    end

    tests("#get_object('fognonbucket', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].get_object('fognonbucket', 'fog_non_object')
    end

    tests("#get_object('#{@directory.identity}', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].get_object(@directory.identity, 'fog_non_object')
    end

    tests("#head_object('fognonbucket', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].head_object('fognonbucket', 'fog_non_object')
    end

    tests("#head_object('#{@directory.identity}', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].head_object(@directory.identity, 'fog_non_object')
    end

    tests("#delete_object('fognonbucket', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].delete_object('fognonbucket', 'fog_non_object')
    end

  end

  @directory.destroy

end
