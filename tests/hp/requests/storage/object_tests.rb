Shindo.tests("Fog::Storage[:hp] | object requests", ['hp', 'storage']) do

  @directory = Fog::Storage[:hp].directories.create(:key => 'fogobjecttests')
  @dir_name = @directory.identity

  tests('success') do

    tests("#put_object('#{@dir_name}', 'fog_object')").succeeds do
      Fog::Storage[:hp].put_object(@dir_name, 'fog_object', lorem_file)
    end

    tests("#post_object('#{@dir_name}', 'fog_object', {'X-Object-Meta-Foo' => 'foometa'})").succeeds do
      Fog::Storage[:hp].post_object(@dir_name, 'fog_object', {'X-Object-Meta-Foo' => 'foometa'})
    end

    tests("#get_object('#{@dir_name}', 'fog_object')").succeeds do
      Fog::Storage[:hp].get_object(@dir_name, 'fog_object')
    end

    tests("#get_object('#{@dir_name}', 'fog_object', &block)").returns(lorem_file.read) do
      data = ''
      Fog::Storage[:hp].get_object(@dir_name, 'fog_object') do |chunk, remaining_bytes, total_bytes|
        data << chunk
      end
      data
    end

    tests("#head_object('#{@dir_name}', 'fog_object')").succeeds do
      Fog::Storage[:hp].head_object(@dir_name, 'fog_object')
    end

    tests("#get_object_temp_url('#{@dir_name}', 'fog_object', 60, 'GET')").succeeds do
      Fog::Storage[:hp].get_object_temp_url(@dir_name, 'fog_object', 60, 'GET')
    end

    # copy a file within the same container
    tests("#put_object('#{@dir_name}', 'fog_other_object', nil, {'X-Copy-From' => '/#{@dir_name}/fog_object'})" ).succeeds do
      Fog::Storage[:hp].put_object(@dir_name, 'fog_other_object', nil, {'X-Copy-From' => "/#{@dir_name}/fog_object"})
    end
    @directory.files.get('fog_other_object').destroy

    # copy a file from one container to another
    @another_dir = Fog::Storage[:hp].directories.create(:key => 'fogobjecttests2')
    tests("#put_object('#{@another_dir.identity}', 'fog_another_object', nil, {'X-Copy-From' => '/#{@dir_name}/fog_object'})" ).succeeds do
      Fog::Storage[:hp].put_object(@another_dir.identity, 'fog_another_object', nil, {'X-Copy-From' => "/#{@dir_name}/fog_object"})
    end
    @another_dir.files.get('fog_another_object').destroy
    @another_dir.destroy

    tests("#post_object('#{@dir_name}', 'fog_delete_object', {'X-Delete-After' => 40})" ).succeeds do
      Fog::Storage[:hp].put_object(@dir_name, 'fog_delete_object', lorem_file)
      Fog::Storage[:hp].post_object(@dir_name, 'fog_delete_object', {'X-Delete-After' => 40})
    end

    tests("#delete_object('#{@dir_name}', 'fog_object')").succeeds do
      Fog::Storage[:hp].delete_object(@dir_name, 'fog_object')
      Fog::Storage[:hp].delete_object(@dir_name, 'fog_delete_object')
    end

    tests("#get_object_http_url('#{@directory.identity}', 'fog_object', expiration timestamp)").returns(true) do
      object_url = Fog::Storage[:hp].get_object_http_url(@dir_name, 'fog_object', (Time.now + 60))
      object_url.include? "fog_object"
      object_url.include? "&temp_url_expires="
      object_url.include? "temp_url_sig="
      object_url.include? @dir_name
      object_url.start_with? "http://"
    end

    tests("#get_object_https_url('#{@directory.identity}', 'fog_object', expiration timestamp)").returns(true) do
      object_url = Fog::Storage[:hp].get_object_https_url(@dir_name, 'fog_object', (Time.now + 60))
      object_url.include? "fog_object"
      object_url.include? "&temp_url_expires="
      object_url.include? "temp_url_sig="
      object_url.include? @dir_name
      object_url.start_with? "https://"
    end
  end

  tests('failure') do

    tests("#put_object('fognoncontainer', 'fog_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].put_object('fognoncontainer', 'fog_object', lorem_file)
    end

    tests("#post_object('fognoncontainer', 'fog_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].post_object('fognoncontainer', 'fog_object')
    end

    tests("#get_object('#{@dir_name}', 'fog_non_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].get_object(@dir_name, 'fog_non_object')
    end

    tests("#get_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].get_object('fognoncontainer', 'fog_non_object')
    end

    tests("#get_object_temp_url('#{@dir_name}', 'fog_object', 60, 'POST')").raises(ArgumentError) do
      Fog::Storage[:hp].get_object_temp_url(@dir_name, 'fog_object', 60, 'POST')
    end

    tests("#head_object('#{@dir_name}', 'fog_non_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].head_object(@dir_name, 'fog_non_object')
    end

    tests("#head_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].head_object('fognoncontainer', 'fog_non_object')
    end

    tests("#delete_object('#{@dir_name}', 'fog_non_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].delete_object(@dir_name, 'fog_non_object')
    end

    tests("#delete_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].delete_object('fognoncontainer', 'fog_non_object')
    end

  end

  @directory.destroy

end
