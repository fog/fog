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

    tests("#get_object('fogobjectests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].get_object('fogobjecttests', 'fog_object').body == lorem_file.read
    end

    tests("#get_object('fogobjecttests', 'fog_object', &block)").succeeds do
      pending if Fog.mocking?
      data = ''
      Fog::Storage[:openstack].get_object('fogobjecttests', 'fog_object') do |chunk, remaining_bytes, total_bytes|
        data << chunk
      end
      data == lorem_file.read
    end

    tests("#public_url('fogobjectests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].directories.first.files.first.public_url
    end

    tests("#public_url('fogobjectests')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].directories.first.public_url
    end

    tests("#head_object('fogobjectests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].head_object('fogobjecttests', 'fog_object')
    end

    tests("#delete_object('fogobjecttests', 'fog_object')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:openstack].delete_object('fogobjecttests', 'fog_object')
    end

    def test_temp_url(url_s, time, desired_scheme)
      object_url = URI.parse(url_s)
      query_params = URI.decode_www_form(object_url.query)

      tests("the link is #{desired_scheme}").returns(desired_scheme) { object_url.scheme }
      tests('the container and object are present in the path').returns(true) do
        (object_url.path =~ /\/#{@directory.identity}\/fog_object/) != nil
      end
      tests('a temp_url_sig is present').returns(true) do
        query_params.any? { |p| p[0] == 'temp_url_sig' }
      end
      tests('temp_url_expires matches the expiration').returns(true) do
        query_params.any? { |p| p == ['temp_url_expires', time.to_i.to_s] }
      end
    end

    tests("#get_object_http_url('directory.identity', 'fog_object', expiration timestamp)").succeeds do
      pending if Fog.mocking?
      ts = Time.at(1395343213)
      url_s = Fog::Storage[:openstack].get_object_http_url(@directory.identity, 'fog_object', ts)
      test_temp_url(url_s, ts, 'http')
    end

    tests("#get_object_https_url('directory.identity', 'fog_object', expiration timestamp)").succeeds do
      pending if Fog.mocking?
      ts = Time.at(1395343215)
      url_s = Fog::Storage[:openstack].get_object_https_url(@directory.identity, 'fog_object', ts)
      test_temp_url(url_s, ts, 'https')
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

    tests('#delete_multiple_objects') do
      pending if Fog.mocking?

      Fog::Storage[:openstack].put_object('fogobjecttests', 'fog_object', lorem_file)
      Fog::Storage[:openstack].put_object('fogobjecttests', 'fog_object2', lorem_file)
      Fog::Storage[:openstack].directories.create(:key => 'fogobjecttests2')
      Fog::Storage[:openstack].put_object('fogobjecttests2', 'fog_object', lorem_file)

      expected = {
        "Number Not Found"  => 0,
        "Response Status"   => "200 OK",
        "Errors"            => [],
        "Number Deleted"    => 2,
        "Response Body"     => ""
      }

      returns(expected, 'deletes multiple objects') do
        Fog::Storage[:openstack].delete_multiple_objects('fogobjecttests', ['fog_object', 'fog_object2']).body
      end

      returns(expected, 'deletes object and container') do
        Fog::Storage[:openstack].delete_multiple_objects(nil, ['fogobjecttests2/fog_object', 'fogobjecttests2']).body
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

    tests('#delete_multiple_objects') do
      pending if Fog.mocking?

      expected = {
        "Number Not Found"  => 2,
        "Response Status"   => "200 OK",
        "Errors"            => [],
        "Number Deleted"    => 0,
        "Response Body"     => ""
      }

      returns(expected, 'reports missing objects') do
        Fog::Storage[:openstack].delete_multiple_objects('fogobjecttests', ['fog_non_object', 'fog_non_object2']).body
      end

      returns(expected, 'reports missing container') do
        Fog::Storage[:openstack].delete_multiple_objects('fognoncontainer', ['fog_non_object', 'fog_non_object2']).body
      end

      tests('deleting non-empty container') do
        Fog::Storage[:openstack].put_object('fogobjecttests', 'fog_object', lorem_file)

        expected = {
          "Number Not Found"  => 0,
          "Response Status"   => "400 Bad Request",
          "Errors"            => [['fogobjecttests', '409 Conflict']],
          "Number Deleted"    => 1,
          "Response Body"     => ""
        }

        returns(expected, 'deletes object but not container') do
          Fog::Storage[:openstack].delete_multiple_objects(nil, ['fogobjecttests', 'fogobjecttests/fog_object']).body
        end
      end
    end
  end

  unless Fog.mocking?
    @directory.destroy
  end

end
