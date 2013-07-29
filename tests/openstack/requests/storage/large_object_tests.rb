Shindo.tests('Fog::Storage[:openstack] | large object requests', ['openstack']) do

  unless Fog.mocking?
    @directory  = Fog::Storage[:openstack].directories.create(:key => 'foglargeobjecttests')
    @directory2 = Fog::Storage[:openstack].directories.create(:key => 'foglargeobjecttests2')
    @segments = {
      :a => {
        :container => @directory.identity,
        :name      => 'fog_large_object/a',
        :data      => 'a' * (1024**2 + 10),
        :size      => 1024**2 + 10,
        :etag      => 'c2e97007d59f0c19b850debdcb80cca5'
      },
      :b => {
        :container => @directory.identity,
        :name      => 'fog_large_object/b',
        :data      => 'b' * (1024**2 + 20),
        :size      => 1024**2 + 20,
        :etag      => 'd35f50622a1259daad75ff7d5512c7ef'
      },
      :c => {
        :container => @directory.identity,
        :name      => 'fog_large_object2/a',
        :data      => 'c' * (1024**2 + 30),
        :size      => 1024**2 + 30,
        :etag      => '901d3531a87d188041d4d5b43cb464c1'
      },
      :d => {
        :container => @directory2.identity,
        :name      => 'fog_large_object2/b',
        :data      => 'd' * (1024**2 + 40),
        :size      => 1024**2 + 40,
        :etag      => '350c0e00525198813920a157df185c8d'
      }
    }
  end

  tests('success') do

    tests('upload test segments').succeeds do
      pending if Fog.mocking?

      @segments.each_value do |segment|
        Fog::Storage[:openstack].put_object(segment[:container], segment[:name], segment[:data])
      end
    end

    tests('dynamic large object requests') do
      pending if Fog.mocking?

      tests('#put_object_manifest alias').succeeds do
        Fog::Storage[:openstack].put_object_manifest(@directory.identity, 'fog_large_object')
      end

      tests('using default X-Object-Manifest header') do

        tests('#put_dynamic_obj_manifest').succeeds do
          Fog::Storage[:openstack].put_dynamic_obj_manifest(@directory.identity, 'fog_large_object')
        end

        tests('#get_object streams all segments matching the default prefix').succeeds do
          expected = @segments[:a][:data] + @segments[:b][:data] + @segments[:c][:data]
          Fog::Storage[:openstack].get_object(@directory.identity, 'fog_large_object').body == expected
        end

        # When the manifest object name is equal to the segment prefix, OpenStack treats it as if it's the first segment.
        # So you must prepend the manifest object's Etag - Digest::MD5.hexdigest('')
        tests('#head_object returns Etag that includes manifest object in calculation').succeeds do
          etags = ['d41d8cd98f00b204e9800998ecf8427e', @segments[:a][:etag], @segments[:b][:etag], @segments[:c][:etag]]
          expected = "\"#{ Digest::MD5.hexdigest(etags.join) }\"" # returned in quotes "\"2577f38428e895c50de6ea78ccc7da2a"\"
          Fog::Storage[:openstack].head_object(@directory.identity, 'fog_large_object').headers['Etag'] == expected
        end

      end

      tests('specifying X-Object-Manifest segment prefix') do

        tests('#put_dynamic_obj_manifest').succeeds do
          options = { 'X-Object-Manifest' => "#{ @directory.identity }/fog_large_object/" }
          Fog::Storage[:openstack].put_dynamic_obj_manifest(@directory.identity, 'fog_large_object', options)
        end

        tests('#get_object streams segments only matching the specified prefix').succeeds do
          expected = @segments[:a][:data] + @segments[:b][:data]
          Fog::Storage[:openstack].get_object(@directory.identity, 'fog_large_object').body == expected
        end

        tests('#head_object returns Etag that does not include manifest object in calculation').succeeds do
          etags = [@segments[:a][:etag], @segments[:b][:etag]]
          expected = "\"#{ Digest::MD5.hexdigest(etags.join) }\"" # returned in quotes "\"0f035ed3cc38aa0ef46dda3478fad44d"\"
          Fog::Storage[:openstack].head_object(@directory.identity, 'fog_large_object').headers['Etag'] == expected
        end

      end

      tests('storing manifest in a different container than the segments') do

        tests('#put_dynamic_obj_manifest').succeeds do
          options = { 'X-Object-Manifest' => "#{ @directory.identity }/fog_large_object/" }
          Fog::Storage[:openstack].put_dynamic_obj_manifest(@directory2.identity, 'fog_large_object', options)
        end

        tests('#get_object').succeeds do
          expected = @segments[:a][:data] + @segments[:b][:data]
          Fog::Storage[:openstack].get_object(@directory2.identity, 'fog_large_object').body == expected
        end

      end

    end

    tests('static large object requests') do
      pending if Fog.mocking?

      tests('single container') do

        tests('#put_static_obj_manifest').succeeds do
          segments = [
            { :path => "#{ @segments[:a][:container] }/#{ @segments[:a][:name] }",
              :etag => @segments[:a][:etag],
              :size_bytes => @segments[:a][:size] },
            { :path => "#{ @segments[:c][:container] }/#{ @segments[:c][:name] }",
              :etag => @segments[:c][:etag],
              :size_bytes => @segments[:c][:size] }
          ]
          Fog::Storage[:openstack].put_static_obj_manifest(@directory.identity, 'fog_large_object', segments)
        end

        tests('#head_object') do
          etags = [@segments[:a][:etag], @segments[:c][:etag]]
          etag = "\"#{ Digest::MD5.hexdigest(etags.join) }\"" # "\"ad7e633a12e8a4915b45e6dd1d4b0b4b\""
          content_length = (@segments[:a][:size] + @segments[:c][:size]).to_s
          response = Fog::Storage[:openstack].head_object(@directory.identity, 'fog_large_object')

          returns(etag, 'returns ETag computed from segments') { response.headers['Etag'] }
          returns(content_length , 'returns Content-Length for all segments') { response.headers['Content-Length'] }
          returns('True', 'returns X-Static-Large-Object header') { response.headers['X-Static-Large-Object'] }
        end

        tests('#get_object').succeeds do
          expected = @segments[:a][:data] + @segments[:c][:data]
          Fog::Storage[:openstack].get_object(@directory.identity, 'fog_large_object').body == expected
        end

        tests('#delete_static_large_object') do
          expected = {
            'Number Not Found'  => 0,
            'Response Status'   => '200 OK',
            'Errors'            => [],
            'Number Deleted'    => 3,
            'Response Body'     => ''
          }
          returns(expected, 'deletes manifest and segments') do
            Fog::Storage[:openstack].delete_static_large_object(@directory.identity, 'fog_large_object').body
          end
        end

      end

      tests('multiple containers') do

        tests('#put_static_obj_manifest').succeeds do
          segments = [
            { :path => "#{ @segments[:b][:container] }/#{ @segments[:b][:name] }",
              :etag => @segments[:b][:etag],
              :size_bytes => @segments[:b][:size] },
            { :path => "#{ @segments[:d][:container] }/#{ @segments[:d][:name] }",
              :etag => @segments[:d][:etag],
              :size_bytes => @segments[:d][:size] }
          ]
          Fog::Storage[:openstack].put_static_obj_manifest(@directory2.identity, 'fog_large_object', segments)
        end

        tests('#head_object') do
          etags = [@segments[:b][:etag], @segments[:d][:etag]]
          etag = "\"#{ Digest::MD5.hexdigest(etags.join) }\"" # "\"9801a4cc4472896a1e975d03f0d2c3f8\""
          content_length = (@segments[:b][:size] + @segments[:d][:size]).to_s
          response = Fog::Storage[:openstack].head_object(@directory2.identity, 'fog_large_object')

          returns(etag, 'returns ETag computed from segments') { response.headers['Etag'] }
          returns(content_length , 'returns Content-Length for all segments') { response.headers['Content-Length'] }
          returns('True', 'returns X-Static-Large-Object header') { response.headers['X-Static-Large-Object'] }
        end

        tests('#get_object').succeeds do
          expected = @segments[:b][:data] + @segments[:d][:data]
          Fog::Storage[:openstack].get_object(@directory2.identity, 'fog_large_object').body == expected
        end

        tests('#delete_static_large_object') do
          expected = {
            'Number Not Found'  => 0,
            'Response Status'   => '200 OK',
            'Errors'            => [],
            'Number Deleted'    => 3,
            'Response Body'     => ''
          }
          returns(expected, 'deletes manifest and segments') do
            Fog::Storage[:openstack].delete_static_large_object(@directory2.identity, 'fog_large_object').body
          end
        end

      end

    end

  end

  tests('failure') do

    tests('dynamic large object requests') do
      pending if Fog.mocking?

      tests('#put_dynamic_obj_manifest with missing container').raises(Fog::Storage::OpenStack::NotFound) do
        Fog::Storage[:openstack].put_dynamic_obj_manifest('fognoncontainer', 'fog_large_object')
      end

    end

    tests('static large object requests') do
      pending if Fog.mocking?

      tests('upload test segments').succeeds do
        Fog::Storage[:openstack].put_object(@segments[:a][:container], @segments[:a][:name], @segments[:a][:data])
        Fog::Storage[:openstack].put_object(@segments[:b][:container], @segments[:b][:name], @segments[:b][:data])
      end

      tests('#put_static_obj_manifest with missing container').raises(Fog::Storage::OpenStack::NotFound) do
        Fog::Storage[:openstack].put_static_obj_manifest('fognoncontainer', 'fog_large_object', [])
      end

      tests('#put_static_obj_manifest with missing object') do
        segments = [
          { :path => "#{ @segments[:c][:container] }/#{ @segments[:c][:name] }",
            :etag => @segments[:c][:etag],
            :size_bytes => @segments[:c][:size] }
        ]
        expected = { 'Errors' => [[segments[0][:path], '404 Not Found']] }

        error = nil
        begin
          Fog::Storage[:openstack].put_static_obj_manifest(@directory.identity, 'fog_large_object', segments)
        rescue => err
          error = err
        end

        raises(Excon::Errors::BadRequest) do
          raise error if error
        end

        returns(expected, 'returns error information') do
          Fog::JSON.decode(error.response.body)
        end
      end

      tests('#put_static_obj_manifest with invalid etag') do
        segments = [
          { :path => "#{ @segments[:a][:container] }/#{ @segments[:a][:name] }",
            :etag => @segments[:b][:etag],
            :size_bytes => @segments[:a][:size] }
        ]
        expected = { 'Errors' => [[segments[0][:path], 'Etag Mismatch']] }

        error = nil
        begin
          Fog::Storage[:openstack].put_static_obj_manifest(@directory.identity, 'fog_large_object', segments)
        rescue => err
          error = err
        end

        raises(Excon::Errors::BadRequest) do
          raise error if error
        end

        returns(expected, 'returns error information') do
          Fog::JSON.decode(error.response.body)
        end
      end

      tests('#put_static_obj_manifest with invalid byte_size') do
        segments = [
          { :path => "#{ @segments[:a][:container] }/#{ @segments[:a][:name] }",
            :etag => @segments[:a][:etag],
            :size_bytes => @segments[:b][:size] }
        ]
        expected = { 'Errors' => [[segments[0][:path], 'Size Mismatch']] }

        error = nil
        begin
          Fog::Storage[:openstack].put_static_obj_manifest(@directory.identity, 'fog_large_object', segments)
        rescue => err
          error = err
        end

        raises(Excon::Errors::BadRequest) do
          raise error if error
        end

        returns(expected, 'returns error information') do
          Fog::JSON.decode(error.response.body)
        end
      end

      tests('#delete_static_large_object with missing container') do
        expected = {
          'Number Not Found'  => 1,
          'Response Status'   => '200 OK',
          'Errors'            => [],
          'Number Deleted'    => 0,
          'Response Body'     => ''
        }

        returns(expected, 'reports missing object') do
          Fog::Storage[:openstack].delete_static_large_object('fognoncontainer', 'fog_large_object').body
        end
      end

      tests('#delete_static_large_object with missing manifest') do
        expected = {
          'Number Not Found'  => 1,
          'Response Status'   => '200 OK',
          'Errors'            => [],
          'Number Deleted'    => 0,
          'Response Body'     => ''
        }

        returns(expected, 'reports missing manifest') do
          Fog::Storage[:openstack].delete_static_large_object(@directory.identity, 'fog_non_object').body
        end
      end

      tests('#delete_static_large_object with missing segment') do

        tests('#put_static_obj_manifest for segments :a and :b').succeeds do
          segments = [
            { :path => "#{ @segments[:a][:container] }/#{ @segments[:a][:name] }",
              :etag => @segments[:a][:etag],
              :size_bytes => @segments[:a][:size] },
            { :path => "#{ @segments[:b][:container] }/#{ @segments[:b][:name] }",
              :etag => @segments[:b][:etag],
              :size_bytes => @segments[:b][:size] }
          ]
          Fog::Storage[:openstack].put_static_obj_manifest(@directory.identity, 'fog_large_object', segments)
        end

        tests('#delete_object segment :b').succeeds do
          Fog::Storage[:openstack].delete_object(@segments[:b][:container], @segments[:b][:name])
        end

        tests('#delete_static_large_object') do
          expected = {
            'Number Not Found'  => 1,
            'Response Status'   => '200 OK',
            'Errors'            => [],
            'Number Deleted'    => 2,
            'Response Body'     => ''
          }
          returns(expected, 'deletes manifest and segment :a, and reports missing segment :b') do
            Fog::Storage[:openstack].delete_static_large_object(@directory.identity, 'fog_large_object').body
          end
        end

      end
    end

  end

  unless Fog.mocking?
    @directory.destroy
    @directory2.destroy
  end
end
