module Fog
  module AWS
    module S3
      class Real

        # List information about objects in an S3 bucket
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to list object keys from
        # * options<~Hash> - config arguments for list.  Defaults to {}.
        #   * 'prefix'<~String> - limits object keys to those beginning with its value.
        #   * 'marker'<~String> - limits object keys to only those that appear
        #     lexicographically after its value.
        #   * 'max-keys'<~Integer> - limits number of object keys returned
        #   * 'delimiter'<~String> - causes keys with the same string between the prefix
        #     value and the first occurence of delimiter to be rolled up
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Delimeter'<~String> - Delimiter specified for query
        #     * 'Marker'<~String> - Marker specified for query
        #     * 'MaxKeys'<~Integer> - Maximum number of keys specified for query
        #     * 'Name'<~String> - Name of the bucket
        #     * 'Prefix'<~String> - Prefix specified for query
        #     * 'Contents'<~Array>:
        #       * 'ETag'<~String>: Etag of object
        #       * 'Key'<~String>: Name of object
        #       * 'LastModified'<~String>: Timestamp of last modification of object
        #       * 'Owner'<~Hash>:
        #         * 'DisplayName'<~String> - Display name of object owner
        #         * 'ID'<~String> - Id of object owner
        #       * 'Size'<~Integer> - Size of object
        #       * 'StorageClass'<~String> - Storage class of object
        def get_bucket(bucket_name, options = {})
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          options.reject! {|key, value| !['prefix', 'marker', 'max-keys', 'delimiter'].include?(key)}
          query = ''
          for key, value in options
            query << "#{key}=#{CGI.escape(value.to_s).gsub(/\+/, '%20')};"
          end
          query.chop!
          request({
            :expects  => 200,
            :headers  => {},
            :host     => "#{bucket_name}.#{@host}",
            :idempotent => true,
            :method   => 'GET',
            :parser   => Fog::Parsers::AWS::S3::GetBucket.new,
            :query    => query
          })
        end

      end

      class Mock

        def get_bucket(bucket_name, options = {})
          unless bucket_name
            raise ArgumentError.new('bucket_name is required')
          end
          response = Excon::Response.new
          if bucket = @data[:buckets][bucket_name]
            response.status = 200
            response.body = {
              'Contents' => bucket[:objects].values.sort {|x,y| x['Key'] <=> y['Key']}.reject do |object|
                  (options['prefix'] && object['Key'][0...options['prefix'].length] != options['prefix']) ||
                  (options['marker'] && object['Key'] <= options['marker'])
                end.map do |object|
                  data = object.reject {|key, value| !['ETag', 'Key', 'LastModified', 'Size', 'StorageClass'].include?(key)}
                  data.merge!({
                    'LastModified' => Time.parse(data['LastModified']),
                    'Owner'        => bucket['Owner'],
                    'Size'         => data['Size'].to_i
                  })
                data
              end,
              'IsTruncated' => false,
              'Marker'      => options['marker'],
              'MaxKeys'     => options['max-keys'] || 1000,
              'Name'        => bucket['Name'],
              'Prefix'      => options['prefix']
            }
            if options['max-keys'] && options['max-keys'] < response.body['Contents'].length
                response.body['IsTruncated'] = true
                response.body['Contents'] = response.body['Contents'][0...options['max-keys']]
            end
          else
            response.status = 404
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          response
        end

      end
    end
  end
end
