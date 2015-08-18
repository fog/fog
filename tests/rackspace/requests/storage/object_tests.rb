require 'uri'
require 'cgi'

Shindo.tests('Fog::Storage[:rackspace] | object requests', ["rackspace"]) do

  @directory = Fog::Storage[:rackspace].directories.create(:key => 'fogobjecttests')

  module RackspaceStorageHelpers
    def override_path(path)
      @uri.path = path
    end
  end

  def parse_url(url_string)
    uri = URI.parse(url_string)
    query_hash = CGI.parse(uri.query)
    query_hash.each do |k, v|
      query_hash[k] = v[0] if query_hash[k].is_a?(Array) and query_hash[k].count == 1
    end
    {
        :scheme => uri.scheme,
        :host => uri.host,
        :port => uri.port,
        :path => uri.path,
        :query => query_hash
    }
  end

  tests('success') do

    tests("#put_object('fogobjecttests', 'fog_object')").succeeds do
      Fog::Storage[:rackspace].put_object('fogobjecttests', 'fog_object', lorem_file)
    end

    tests("#get_object('fogobjectests', 'fog_object')").succeeds do
      Fog::Storage[:rackspace].get_object('fogobjecttests', 'fog_object').body == lorem_file.read
    end

    tests("#get_object('fogobjecttests', 'fog_object', &block)").succeeds do
      data = ''
      Fog::Storage[:rackspace].get_object('fogobjecttests', 'fog_object') do |chunk, remaining_bytes, total_bytes|
        data << chunk
      end
      data == lorem_file.read
    end

    tests("#head_object('fogobjectests', 'fog_object')").succeeds do
      Fog::Storage[:rackspace].head_object('fogobjecttests', 'fog_object')
    end

    tests("#delete_object('fogobjecttests', 'fog_object')").succeeds do
      Fog::Storage[:rackspace].delete_object('fogobjecttests', 'fog_object')
    end

    # an object key with no special characters
    tests("#get_object_http_url('fogobjecttests', 'fog_object','expiration timestamp')").succeeds do
      expires_at = 1344149532 # 2012-08-05 16:52:12 +1000
      storage    = Fog::Storage::Rackspace.new(:rackspace_temp_url_key => "super_secret")
      storage.extend RackspaceStorageHelpers
      storage.override_path('/fake_version/fake_tenant')
      object_url = storage.get_object_http_url('fogobjecttests', 'fog_object', expires_at)
      url = parse_url(object_url)
      [
         url[:host] =~ /.*clouddrive\.com$/,
         url[:path] =~ /\/fogobjecttests\/fog_object$/,
         url[:query]['temp_url_sig'] == '7e69a73092e333095a70b3be826a7350fcbede86',
         url[:query]['temp_url_expires'] == '1344149532'
      ].all?
    end

    # an object key with no special characters
    tests("#get_object_https_url('fogobjecttests', 'fog_object','expiration timestamp')").succeeds do
      expires_at = 1344149532 # 2012-08-05 16:52:12 +1000
      storage    = Fog::Storage::Rackspace.new(:rackspace_temp_url_key => "super_secret")
      storage.extend RackspaceStorageHelpers
      storage.override_path('/fake_version/fake_tenant')
      object_url = storage.get_object_https_url('fogobjecttests', 'fog_object', expires_at)
      url = parse_url(object_url)
      [
          url[:host] =~ /.*clouddrive\.com$/,
          url[:path] =~ /\/fogobjecttests\/fog_object$/,
          url[:query]['temp_url_sig'] == '7e69a73092e333095a70b3be826a7350fcbede86',
          url[:query]['temp_url_expires'] == '1344149532'
      ].all?
    end

    # an object key nested under a /
    tests("#get_object_https_url('fogobjecttests', 'fog/object','expiration timestamp')").succeeds do
      expires_at = 1344149532 # 2012-08-05 16:52:12 +1000
      storage    = Fog::Storage::Rackspace.new(:rackspace_temp_url_key => "super_secret")
      storage.extend RackspaceStorageHelpers
      storage.override_path('/fake_version/fake_tenant')
      object_url = storage.get_object_https_url('fogobjecttests', 'fog/object', expires_at)
      url = parse_url(object_url)
      [
          url[:host] =~ /.*clouddrive\.com$/,
          url[:path] =~ /\/fogobjecttests\/fog\/object$/,
          url[:query]['temp_url_sig'] == '3e99892828804e3d0fdadd18c543b688591ca8b8',
          url[:query]['temp_url_expires'] == '1344149532'
      ].all?
    end

    # an object key containing a -
    tests("#get_object_https_url('fogobjecttests', 'fog-object','expiration timestamp')").succeeds do
      expires_at = 1344149532 # 2012-08-05 16:52:12 +1000
      storage    = Fog::Storage::Rackspace.new(:rackspace_temp_url_key => "super_secret")
      storage.extend RackspaceStorageHelpers
      storage.override_path('/fake_version/fake_tenant')
      object_url = storage.get_object_https_url('fogobjecttests', 'fog-object', expires_at)
      url = parse_url(object_url)
      [
          url[:host] =~ /.*clouddrive\.com$/,
          url[:path] =~ /\/fogobjecttests\/fog-object$/,
          url[:query]['temp_url_sig'] == 'a24dd5fc955a57adce7d1b5bc4ec2c7660ab8396',
          url[:query]['temp_url_expires'] == '1344149532'
      ].all?
    end

    tests("put_object with block") do
      tests("#put_object('fogobjecttests', 'fog_object', &block)").succeeds do
        begin
          file = lorem_file
          buffer_size = file.stat.size / 2 # chop it up into two buffers
          Fog::Storage[:rackspace].put_object('fogobjecttests', 'fog_block_object', nil) do
            file.read(buffer_size).to_s
          end
        ensure
          file.close
        end
      end

      tests('#get_object').succeeds do
        Fog::Storage[:rackspace].get_object('fogobjecttests', 'fog_block_object').body == lorem_file.read
      end

      tests('#delete_object').succeeds do
        Fog::Storage[:rackspace].delete_object('fogobjecttests', 'fog_block_object')
      end
    end

    tests('#delete_multiple_objects') do
      Fog::Storage[:rackspace].put_object('fogobjecttests', 'fog_object', lorem_file)
      Fog::Storage[:rackspace].put_object('fogobjecttests', 'fog_object2', lorem_file)
      Fog::Storage[:rackspace].directories.create(:key => 'fogobjecttests2')
      Fog::Storage[:rackspace].put_object('fogobjecttests2', 'fog_object', lorem_file)

      expected = {
        "Number Not Found"  => 0,
        "Response Status"   => "200 OK",
        "Errors"            => [],
        "Number Deleted"    => 2,
        "Response Body"     => ""
      }

      returns(expected, 'deletes multiple objects') do
        Fog::Storage[:rackspace].delete_multiple_objects('fogobjecttests', ['fog_object', 'fog_object2']).body
      end

      returns(expected, 'deletes object and container') do
        Fog::Storage[:rackspace].delete_multiple_objects(nil, ['fogobjecttests2/fog_object', 'fogobjecttests2']).body
      end
    end

  end

  tests('failure') do

    tests("#get_object('fogobjecttests', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::Storage[:rackspace].get_object('fogobjecttests', 'fog_non_object')
    end

    tests("#get_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::Storage[:rackspace].get_object('fognoncontainer', 'fog_non_object')
    end

    tests("#head_object('fogobjecttests', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::Storage[:rackspace].head_object('fogobjecttests', 'fog_non_object')
    end

    tests("#head_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::Storage[:rackspace].head_object('fognoncontainer', 'fog_non_object')
    end

    tests("#delete_object('fogobjecttests', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::Storage[:rackspace].delete_object('fogobjecttests', 'fog_non_object')
    end

    tests("#delete_object('fognoncontainer', 'fog_non_object')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::Storage[:rackspace].delete_object('fognoncontainer', 'fog_non_object')
    end

    tests('#delete_multiple_objects') do
      expected = {
        "Number Not Found"  => 2,
        "Response Status"   => "200 OK",
        "Errors"            => [],
        "Number Deleted"    => 0,
        "Response Body"     => ""
      }

      returns(expected, 'reports missing objects') do
        Fog::Storage[:rackspace].delete_multiple_objects('fogobjecttests', ['fog_non_object', 'fog_non_object2']).body
      end

      returns(expected, 'reports missing container') do
        Fog::Storage[:rackspace].delete_multiple_objects('fognoncontainer', ['fog_non_object', 'fog_non_object2']).body
      end

      tests('deleting non-empty container') do
        Fog::Storage[:rackspace].put_object('fogobjecttests', 'fog_object', lorem_file)

        expected = {
          "Number Not Found"  => 0,
          "Response Status"   => "400 Bad Request",
          "Errors"            => [['fogobjecttests', '409 Conflict']],
          "Number Deleted"    => 1,
          "Response Body"     => ""
        }

        body = Fog::Storage[:rackspace].delete_multiple_objects(nil, ['fogobjecttests', 'fogobjecttests/fog_object']).body
        expected['Errors'][0][0] = body['Errors'][0][0] rescue nil
        returns(expected, 'deletes object but not container') { body }
      end
    end

  end

  @directory.destroy

end
