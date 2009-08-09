unless Fog.mocking?

  module Fog
    module AWS
      class S3

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
        # * response<~Fog::AWS::Response>:
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
          query = '?'
          for key, value in options
            query << "#{key}=#{value};"
          end
          query.chop!
          request({
            :expects => 200,
            :headers => {},
            :host => "#{bucket_name}.#{@host}",
            :method => 'GET',
            :parser => Fog::Parsers::AWS::S3::GetBucket.new,
            :query => query
          })
        end

      end
    end
  end

else

  module Fog
    module AWS
      class S3

        def get_bucket(bucket_name, options = {})
          response = Fog::Response.new
          bucket = @data['Buckets'].select {|bucket| bucket['Name'] == bucket_name}.first
          unless bucket
            response.status = 404
          else
            response.status = 200
            response.body = {
              'Contents' => bucket['Contents'].map do |object|
                data = object.reject {|key, value| !['ETag', 'Key', 'LastModified', 'Owner', 'Size', 'StorageClass'].include?(key)}
                data['LastModified']  = Time.parse(data['LastModified'])
                data['Size'] = data['Size'].to_i
                data
              end,
              'IsTruncated' => false,
              'Marker'      => options['Marker'] || '',
              'MaxKeys'     => options['MaxKeys'] || 1000,
              'Name'        => bucket['Name'],
              'Prefix'      => options['Prefix'] || ''
            }
          end
          response
        end

      end
    end
  end

end
