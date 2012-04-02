Shindo.tests('Fog::Storage[:hp] | object requests', [:hp]) do

  @directory = Fog::Storage[:hp].directories.create(:key => 'fogobjecttests')
  @dir_name = @directory.identity

  tests('success') do

    tests("#put_object('#{@dir_name}', 'fog_object')").succeeds do
      Fog::Storage[:hp].put_object(@dir_name, 'fog_object', lorem_file)
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

    tests("#put_object('#{@dir_name}', 'fog_other_object', nil, {'X-Copy-From' => '/#{@dir_name}/fog_object'})" ).succeeds do
      Fog::Storage[:hp].put_object(@dir_name, 'fog_other_object', nil, {'X-Copy-From' => "/#{@dir_name}/fog_object"})
    end
    @directory.files.get('fog_other_object').destroy

    tests("#delete_object('#{@dir_name}', 'fog_object')").succeeds do
      Fog::Storage[:hp].delete_object(@dir_name, 'fog_object')
    end
  end

  tests('failure') do

    tests("#put_object('fognoncontainer', 'fog_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].put_object('fognoncontainer', 'fog_object', lorem_file)
    end

    tests("#get_object('#{@dir_name}', 'fog_non_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].get_object(@dir_name, 'fog_non_object')
    end

    tests("#get_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].get_object('fognoncontainer', 'fog_non_object')
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