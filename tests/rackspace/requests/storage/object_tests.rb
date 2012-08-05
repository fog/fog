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

    # an object key with no special characters
    tests("#get_object_https_url('fogobjecttests', 'fog_object','expiration timestamp')").succeeds do
      pending if Fog.mocking?
      expires_at = 1344149532 # 2012-08-05 16:52:12 +1000
      storage    = Fog::Storage::Rackspace.new(:rackspace_temp_url_key => "super_secret")
      object_url = storage.get_object_https_url('fogobjecttests', 'fog_object', expires_at)
      object_url =~ /https:\/\/.*clouddrive.com\/[^\/]+\/[^\/]+\/fogobjecttests\/fog_object\?temp_url_sig=8abd27f8345b6f3c5fceb9ef71d8ac59ffb15500&temp_url_expires=1344149532/
    end

    # an object key nested under a /
    tests("#get_object_https_url('fogobjecttests', 'fog/object','expiration timestamp')").succeeds do
      pending if Fog.mocking?
      expires_at = 1344149532 # 2012-08-05 16:52:12 +1000
      storage    = Fog::Storage::Rackspace.new(:rackspace_temp_url_key => "super_secret")
      object_url = storage.get_object_https_url('fogobjecttests', 'fog/object', expires_at)
      object_url =~ /https:\/\/.*clouddrive.com\/[^\/]+\/[^\/]+\/fogobjecttests\/fog\/object\?temp_url_sig=1dc1de4544f75cf9eba85bde500059472c94adcd&temp_url_expires=1344149532/
    end

    # an object key containing a -
    tests("#get_object_https_url('fogobjecttests', 'fog-object','expiration timestamp')").succeeds do
      pending if Fog.mocking?
      expires_at = 1344149532 # 2012-08-05 16:52:12 +1000
      storage    = Fog::Storage::Rackspace.new(:rackspace_temp_url_key => "super_secret")
      object_url = storage.get_object_https_url('fogobjecttests', 'fog-object', expires_at)
      object_url =~ /https:\/\/.*clouddrive.com\/[^\/]+\/[^\/]+\/fogobjecttests\/fog%2Dobject\?temp_url_sig=f664ec159300d91b2cb735249c630645b55b87a1&temp_url_expires=1344149532/
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
