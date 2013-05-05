Shindo.tests('Fog::Storage[:rackspace] | large object requests', ["rackspace"]) do

  unless Fog.mocking?
    @directory = Fog::Storage[:rackspace].directories.create(:key => 'foglargeobjecttests')
    @directory2 = Fog::Storage[:rackspace].directories.create(:key => 'foglargeobjecttests2')
  end

  tests('success') do

    tests("#put_object('foglargeobjecttests', 'fog_large_object/1', ('x' * 4 * 1024 * 1024))").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].put_object(@directory.identity, 'fog_large_object/1', ('x' * 4 * 1024 * 1024))
    end

    tests("#put_object('foglargeobjecttests', 'fog_large_object/2', ('x' * 2 * 1024 * 1024))").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].put_object(@directory.identity, 'fog_large_object/2', ('x' * 2 * 1024 * 1024))
    end

    tests("#put_object_manifest('foglargeobjecttests', 'fog_large_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].put_object_manifest(@directory.identity, 'fog_large_object')
    end

    tests("#get_object('foglargeobjecttests', 'fog_large_object').body").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].get_object(@directory.identity, 'fog_large_object').body == ('x' * 6 * 1024 * 1024)
    end

    tests("returns manifest Etag, computed including manifest file").succeeds do
      pending if Fog.mocking?

      etags = []
      # When the manifest object name is equal to the prefix for the segments,
      # OpenStack treats it as if it's the first segment.
      etags << Digest::MD5.hexdigest('') # Etag for manifest object => "d41d8cd98f00b204e9800998ecf8427e"
      etags << Digest::MD5.hexdigest('x' * 4 * 1024 * 1024) # => "44981362d3ba9b5bacaf017c2f29d355"
      etags << Digest::MD5.hexdigest('x' * 2 * 1024 * 1024) # => "67b2f816a30e8956149b2d7beb479e51"
      expected = Digest::MD5.hexdigest(etags.join) # => "2537ea40a5a8cac247a912906cb62fc2"
      actual = Fog::Storage[:rackspace].head_object(@directory.identity, 'fog_large_object').headers['Etag']
      actual.gsub('"', '') == expected # actual is returned in quotes "\"2537ea40a5a8cac247a912906cb62fc2"\"
    end

    tests("#delete_object('foglargeobjecttests', 'fog_large_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].delete_object('foglargeobjecttests', 'fog_large_object')
    end

    tests("#put_object_manifest('foglargeobjecttests', 'large_object_manifest', {'segments_prefix' => 'fog_large_object'})").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].put_object_manifest(@directory.identity, 'large_object_manifest', {'segments_prefix' => 'fog_large_object'})
    end

    tests("#get_object('foglargeobjecttests', 'large_object_manifest').body").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].get_object(@directory.identity, 'large_object_manifest').body == ('x' * 6 * 1024 * 1024)
    end

    tests("returns manifest Etag, computed without manifest file").succeeds do
      pending if Fog.mocking?

      etags = []
      etags << Digest::MD5.hexdigest('x' * 4 * 1024 * 1024) # => "44981362d3ba9b5bacaf017c2f29d355"
      etags << Digest::MD5.hexdigest('x' * 2 * 1024 * 1024) # => "67b2f816a30e8956149b2d7beb479e51"
      expected = Digest::MD5.hexdigest(etags.join) # => "0b348495a774eaa4d4c4bbf770820f84"
      actual = Fog::Storage[:rackspace].head_object(@directory.identity, 'large_object_manifest').headers['Etag']
      actual.gsub('"', '') == expected # actual is returned in quotes "\"0b348495a774eaa4d4c4bbf770820f84"\"
    end

    tests("#put_object_manifest('foglargeobjecttests2', 'fog_large_object', {'segments_container' => 'foglargeobjecttests', 'segments_prefix' => 'fog_large_object'})").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].put_object_manifest(@directory2.identity, 'fog_large_object', {'segments_container' => @directory.identity, 'segments_prefix' => 'fog_large_object'})
    end

    tests("#get_object('foglargeobjecttests2', 'fog_large_object').body").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].get_object(@directory2.identity, 'fog_large_object').body == ('x' * 6 * 1024 * 1024)
    end

    tests("returns manifest Etag, computed without manifest file").succeeds do
      pending if Fog.mocking?

      etags = []
      etags << Digest::MD5.hexdigest('x' * 4 * 1024 * 1024) # => "44981362d3ba9b5bacaf017c2f29d355"
      etags << Digest::MD5.hexdigest('x' * 2 * 1024 * 1024) # => "67b2f816a30e8956149b2d7beb479e51"
      expected = Digest::MD5.hexdigest(etags.join) # => "0b348495a774eaa4d4c4bbf770820f84"
      actual = Fog::Storage[:rackspace].head_object(@directory2.identity, 'fog_large_object').headers['Etag']
      actual.gsub('"', '') == expected # actual is returned in quotes "\"0b348495a774eaa4d4c4bbf770820f84"\"
    end

    unless Fog.mocking?
      ['large_object_manifest', 'fog_large_object/1', 'fog_large_object/2'].each do |key|
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
