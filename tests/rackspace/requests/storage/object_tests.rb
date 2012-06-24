Shindo.tests('Fog::Storage[:rackspace] | object requests', [:rackspace]) do

  unless Fog.mocking?
    @directory = Fog::Storage[:rackspace].directories.create(:key => 'fogobjecttests')
  end

  tests('success') do

    tests("#put_object('fogobjecttests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].put_object('fogobjecttests', 'fog_object', lorem_file)
    end

    tests("#get_object('fogobjectests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].get_object('fogobjecttests', 'fog_object')
    end

    tests("#get_object('fogobjecttests', 'fog_object', &block)").returns(lorem_file.read) do
      pending if Fog.mocking?
      data = ''
      Fog::Storage[:rackspace].get_object('fogobjecttests', 'fog_object') do |chunk, remaining_bytes, total_bytes|
        data << chunk
      end
      data
    end

    tests("#head_object('fogobjectests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].head_object('fogobjecttests', 'fog_object')
    end

    tests("#delete_object('fogobjecttests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].delete_object('fogobjecttests', 'fog_object')
    end

    tests("#get_object_https_url('fogobjecttests', 'fog_object','expiration timestamp')").succeeds do
      pending if Fog.mocking?
      expires_at = Time.now + 60
      object_url = Fog::Storage[:rackspace].get_object_https_url('fogobjecttests', 'fog_object', expires_at)
      object_url =~ /https:\/\/.*clouddrive.com\/[^\/]+\/[^\/]+\/fogobjecttests\/fog_object\?temp_url_sig=[0-9a-f]{40}&temp_url_expires=#{expires_at.to_i}/
    end

  end

  tests('failure') do

    tests("#get_object('fogobjecttests', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].get_object('fogobjecttests', 'fog_non_object')
    end

    tests("#get_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].get_object('fognoncontainer', 'fog_non_object')
    end

    tests("#head_object('fogobjecttests', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].head_object('fogobjecttests', 'fog_non_object')
    end

    tests("#head_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].head_object('fognoncontainer', 'fog_non_object')
    end

    tests("#delete_object('fogobjecttests', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].delete_object('fogobjecttests', 'fog_non_object')
    end

    tests("#delete_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].delete_object('fognoncontainer', 'fog_non_object')
    end

  end

  unless Fog.mocking?
    @directory.destroy
  end

end
