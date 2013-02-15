Shindo.tests('Fog::Storage[:openstack] | large object requests', ["openstack"]) do

  unless Fog.mocking?
    @directory = Fog::Storage[:openstack].directories.create(:key => 'foglargeobjecttests')
  end

  tests('success') do

    tests("#put_object('foglargeobjecttests', 'fog_large_object/1', ('x' * 6 * 1024 * 1024))").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].put_object(@directory.identity, 'fog_large_object/1', ('x' * 6 * 1024 * 1024))
    end

    tests("#put_object('foglargeobjecttests', 'fog_large_object/2', ('x' * 4 * 1024 * 1024))").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].put_object(@directory.identity, 'fog_large_object/2', ('x' * 4 * 1024 * 1024))
    end

    tests("#put_object_manifest('foglargeobjecttests', 'fog_large_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].put_object_manifest(@directory.identity, 'fog_large_object')
    end

    tests("#get_object('foglargeobjecttests', 'fog_large_object').body").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].get_object(@directory.identity, 'fog_large_object').body == ('x' * 10 * 1024 * 1024)
    end

    unless Fog.mocking?
      ['fog_large_object', 'fog_large_object/1', 'fog_large_object/2'].each do |key|
        @directory.files.new(:key => key).destroy
      end
    end

  end

  tests('failure') do

    tests("put_object_manifest")

  end

  unless Fog.mocking?
    @directory.destroy
  end

end
