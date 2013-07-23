Shindo.tests('Fog::Storage[:openstack] | object requests', ["openstack"]) do

  unless Fog.mocking?
    @directory = Fog::Storage[:openstack].directories.create(:key => 'fogobjecttests')
  end

  module OpenStackStorageHelpers
    def override_path(path)
      @path = path
    end
  end

  tests('success') do

    tests("#put_object('fogobjecttests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].put_object('fogobjecttests', 'fog_object', lorem_file)
    end

    tests("#get_object('fogobjectests', 'fog_object')").returns(lorem_file.read) do
      pending if Fog.mocking?
      Fog::Storage[:openstack].get_object('fogobjecttests', 'fog_object').body
    end

    tests("#get_object('fogobjecttests', 'fog_object', &block)").returns(lorem_file.read) do
      pending if Fog.mocking?
      data = ''
      Fog::Storage[:openstack].get_object('fogobjecttests', 'fog_object') do |chunk, remaining_bytes, total_bytes|
        data << chunk
      end
      data
    end

    tests("#head_object('fogobjectests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].head_object('fogobjecttests', 'fog_object')
    end

    tests("#delete_object('fogobjecttests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].delete_object('fogobjecttests', 'fog_object')
    end

    tests("put_object with block") do
      pending if Fog.mocking?

      tests("#put_object('fogobjecttests', 'fog_object', &block)").succeeds do
        begin
          file = lorem_file
          buffer_size = file.stat.size / 2 # chop it up into two buffers
          Fog::Storage[:openstack].put_object('fogobjecttests', 'fog_block_object', nil) do
            file.read(buffer_size).to_s
          end
        ensure
          file.close
        end
      end

      tests('#get_object').succeeds do
        Fog::Storage[:openstack].get_object('fogobjecttests', 'fog_block_object').body == lorem_file.read
      end

      tests('#delete_object').succeeds do
        Fog::Storage[:openstack].delete_object('fogobjecttests', 'fog_block_object')
      end
    end


  end

  tests('failure') do

    tests("#get_object('fogobjecttests', 'fog_non_object')").raises(Fog::Storage::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:openstack].get_object('fogobjecttests', 'fog_non_object')
    end

    tests("#get_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:openstack].get_object('fognoncontainer', 'fog_non_object')
    end

    tests("#head_object('fogobjecttests', 'fog_non_object')").raises(Fog::Storage::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:openstack].head_object('fogobjecttests', 'fog_non_object')
    end

    tests("#head_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:openstack].head_object('fognoncontainer', 'fog_non_object')
    end

    tests("#delete_object('fogobjecttests', 'fog_non_object')").raises(Fog::Storage::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:openstack].delete_object('fogobjecttests', 'fog_non_object')
    end

    tests("#delete_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::OpenStack::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:openstack].delete_object('fognoncontainer', 'fog_non_object')
    end

  end

  unless Fog.mocking?
    @directory.destroy
  end

end
