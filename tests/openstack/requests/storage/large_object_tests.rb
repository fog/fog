Shindo.tests('Fog::Storage[:openstack] | large object requests', ["openstack"]) do

  unless Fog.mocking?
    @directory = Fog::Storage[:openstack].directories.create(:key => 'foglargeobjecttests')
    @directory2 = Fog::Storage[:openstack].directories.create(:key => 'foglargeobjecttests2')
  end

  tests('success') do

    tests("#put_object('foglargeobjecttests', 'fog_large_object/1', ('x' * 4 * 1024 * 1024))").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].put_object(@directory.identity, 'fog_large_object/1', ('x' * 4 * 1024 * 1024))
    end

    tests("#put_object('foglargeobjecttests', 'fog_large_object/2', ('x' * 2 * 1024 * 1024))").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].put_object(@directory.identity, 'fog_large_object/2', ('x' * 2 * 1024 * 1024))
    end

    tests("#put_object('foglargeobjecttests', 'fog_large_object2/1', ('x' * 1 * 1024 * 1024))").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].put_object(@directory.identity, 'fog_large_object2/1', ('x' * 1 * 1024 * 1024))
    end

    tests("using default X-Object-Manifest header") do

      tests("#put_object_manifest('foglargeobjecttests', 'fog_large_object')").succeeds do
        pending if Fog.mocking?
        Fog::Storage[:openstack].put_object_manifest(@directory.identity, 'fog_large_object')
      end

      tests("#get_object streams all segments matching the default prefix").succeeds do
        pending if Fog.mocking?
        Fog::Storage[:openstack].get_object(@directory.identity, 'fog_large_object').body == ('x' * 7 * 1024 * 1024)
      end

      tests("#head_object returns Etag that includes manifest object in calculation").succeeds do
        pending if Fog.mocking?

        etags = []
        # When the manifest object name is equal to the prefix, OpenStack treats it as if it's the first segment.
        etags << Digest::MD5.hexdigest('') # Etag for manifest object => "d41d8cd98f00b204e9800998ecf8427e"
        etags << Digest::MD5.hexdigest('x' * 4 * 1024 * 1024) # => "44981362d3ba9b5bacaf017c2f29d355"
        etags << Digest::MD5.hexdigest('x' * 2 * 1024 * 1024) # => "67b2f816a30e8956149b2d7beb479e51"
        etags << Digest::MD5.hexdigest('x' * 1 * 1024 * 1024) # => "b561f87202d04959e37588ee05cf5b10"
        expected = Digest::MD5.hexdigest(etags.join) # => "42e92048bd2c8085e7072b0b55fd76ab"
        actual = Fog::Storage[:openstack].head_object(@directory.identity, 'fog_large_object').headers['Etag']
        actual.gsub('"', '') == expected # actual is returned in quotes "\"42e92048bd2c8085e7072b0b55fd76abu"\"
      end

    end

    tests("specifying X-Object-Manifest segment prefix") do

      tests("#put_object_manifest('foglargeobjecttests', 'fog_large_object', {'X-Object-Manifest' => 'foglargeobjecttests/fog_large_object/')").succeeds do
        pending if Fog.mocking?
        Fog::Storage[:openstack].put_object_manifest(@directory.identity, 'fog_large_object', {'X-Object-Manifest' => "#{@directory.identity}/fog_large_object/"})
      end

      tests("#get_object streams segments only matching the specified prefix").succeeds do
        pending if Fog.mocking?
        Fog::Storage[:openstack].get_object(@directory.identity, 'fog_large_object').body == ('x' * 6 * 1024 * 1024)
      end

      tests("#head_object returns Etag that does not include manifest object in calculation").succeeds do
        pending if Fog.mocking?

        etags = []
        etags << Digest::MD5.hexdigest('x' * 4 * 1024 * 1024) # => "44981362d3ba9b5bacaf017c2f29d355"
        etags << Digest::MD5.hexdigest('x' * 2 * 1024 * 1024) # => "67b2f816a30e8956149b2d7beb479e51"
        expected = Digest::MD5.hexdigest(etags.join) # => "0b348495a774eaa4d4c4bbf770820f84"
        actual = Fog::Storage[:openstack].head_object(@directory.identity, 'fog_large_object').headers['Etag']
        actual.gsub('"', '') == expected # actual is returned in quotes "\"0b348495a774eaa4d4c4bbf770820f84"\"
      end

    end

    tests("storing manifest object in a different container than the segments") do

      tests("#put_object_manifest('foglargeobjecttests2', 'fog_large_object', {'X-Object-Manifest' => 'foglargeobjecttests/fog_large_object/'})").succeeds do
        pending if Fog.mocking?
        Fog::Storage[:openstack].put_object_manifest(@directory2.identity, 'fog_large_object', {'X-Object-Manifest' => "#{@directory.identity}/fog_large_object/"})
      end

      tests("#get_object('foglargeobjecttests2', 'fog_large_object').body").succeeds do
        pending if Fog.mocking?
        Fog::Storage[:openstack].get_object(@directory2.identity, 'fog_large_object').body == ('x' * 6 * 1024 * 1024)
      end

    end

    unless Fog.mocking?
      ['fog_large_object', 'fog_large_object/1', 'fog_large_object/2', 'fog_large_object2/1'].each do |key|
        @directory.files.new(:key => key).destroy
      end
      @directory2.files.new(:key => 'fog_large_object').destroy
    end

  end

  tests('failure') do

    tests("put_object_manifest")

  end

  unless Fog.mocking?
    @directory.destroy
    @directory2.destroy
  end
end
