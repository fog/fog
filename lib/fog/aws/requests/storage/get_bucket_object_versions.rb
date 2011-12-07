module Fog
  module Storage
    class AWS
      class Real

        require 'fog/aws/parsers/storage/get_bucket_object_versions'

        # List information about object versions in an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to list object keys from
        # * options<~Hash> - config arguments for list.  Defaults to {}.
        #   * 'delimiter'<~String> - causes keys with the same string between the prefix
        #     value and the first occurence of delimiter to be rolled up
        #   * 'key-marker'<~String> - limits object keys to only those that appear
        #     lexicographically after its value.
        #   * 'max-keys'<~Integer> - limits number of object keys returned
        #   * 'prefix'<~String> - limits object keys to those beginning with its value.
        #   * 'version-id-marker'<~String> - limits object versions to only those that
        #     appear lexicographically after its value
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Delimeter'<~String> - Delimiter specified for query
        #     * 'KeyMarker'<~String> - Key marker specified for query
        #     * 'MaxKeys'<~Integer> - Maximum number of keys specified for query
        #     * 'Name'<~String> - Name of the bucket
        #     * 'Prefix'<~String> - Prefix specified for query
        #     * 'VersionIdMarker'<~String> - Version id marker specified for query
        #     * 'IsTruncated'<~Boolean> - Whether or not this is the totality of the bucket
        #     * 'Versions'<~Array>:
        #         * 'DeleteMarker'<~Hash>:
        #           * 'IsLatest'<~Boolean> - Whether or not this is the latest version
        #           * 'Key'<~String> - Name of object
        #           * 'LastModified'<~String>: Timestamp of last modification of object
        #           * 'Owner'<~Hash>:
        #             * 'DisplayName'<~String> - Display name of object owner
        #             * 'ID'<~String> - Id of object owner
        #           * 'VersionId'<~String> - The id of this version
        #       or
        #         * 'Version'<~Hash>:
        #           * 'ETag'<~String>: Etag of object
        #           * 'IsLatest'<~Boolean> - Whether or not this is the latest version
        #           * 'Key'<~String> - Name of object
        #           * 'LastModified'<~String>: Timestamp of last modification of object
        #           * 'Owner'<~Hash>:
        #             * 'DisplayName'<~String> - Display name of object owner
        #             * 'ID'<~String> - Id of object owner
        #           * 'Size'<~Integer> - Size of object
        #           * 'StorageClass'<~String> - Storage class of object
        #           * 'VersionId'<~String> - The id of this version
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGETVersion.html

        def get_bucket_object_versions(bucket_name, options = {})
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          request({
            :expects  => 200,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method   => 'GET',
            :parser   => Fog::Parsers::Storage::AWS::GetBucketObjectVersions.new,
            :query    => {'versions' => nil}.merge!(options)          })
        end

      end

      class Mock
        def get_bucket_object_versions(bucket_name, options = {})
          delimiter, key_marker, max_keys, prefix, version_id_marker = \
            options['delimiter'], options['key_marker'], options['max_keys'],options['prefix'],options['version_id_marker']

          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end

          response = Excon::Response.new
          if bucket = self.data[:buckets][bucket_name]
            contents = bucket[:objects].values.flatten.sort {|x,y| x['Key'] <=> y['Key']}.reject do |object|
                (prefix      && object['Key'][0...prefix.length] != prefix) ||
                (key_marker  && object['Key'] <= key_marker) ||
                (delimiter   && object['Key'][(prefix ? prefix.length : 0)..-1].include?(delimiter) \
                             && common_prefixes << object['Key'].sub(/^(#{prefix}[^#{delimiter}]+.).*/, '\1'))
              end.map do |object|
                data = { 'Version' => {} }
                data['Version'] = object.reject {|key, value| !['ETag', 'Key', 'StorageClass', 'VersionId'].include?(key)}
                data['Version'].merge!({
                  'LastModified' => Time.parse(object['Last-Modified']),
                  'Owner'        => bucket['Owner'],
                  'Size'         => object['Content-Length'].to_i,
                  'IsLatest'     => object == bucket[:objects][object['Key']].last
                })
              data
            end

            max_keys = max_keys || 1000
            size = [max_keys, 1000].min
            truncated_contents = contents[0...size]

            response.status = 200
            response.body = {
              'Versions'        => truncated_contents,
              'IsTruncated'     => truncated_contents.size != contents.size,
              'KeyMarker'       => key_marker,
              'VersionIdMarker' => version_id_marker,
              'MaxKeys'         => max_keys,
              'Name'            => bucket['Name'],
              'Prefix'          => prefix
            }
            if max_keys && max_keys < response.body['Versions'].length
                response.body['IsTruncated'] = true
                response.body['Versions'] = response.body['Versions'][0...max_keys]
            end
          else
            response.status = 403
            response.body = {
              'Error' => {
                'Code' => 'AccessDenied',
                'Message' => 'AccessDenied',
                'RequestId' => Fog::Mock.random_hex(16),
                'HostId' => Fog::Mock.random_base64(65)
              }
            }
          end
          response
        end
      end
    end
  end
end
