module Fog
  module AWS
    class S3

      # List information about objects in an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to list object keys from
      # * options<~Hash> - config arguments for list.  Defaults to {}.
      #   * :prefix - limits object keys to those beginning with its value.
      #   * :marker - limits object keys to only those that appear
      #     lexicographically after its value.
      #   * maxkeys - limits number of object keys returned
      #   * :delimiter - causes keys with the same string between the prefix
      #     value and the first occurence of delimiter to be rolled up
      #
      # ==== Returns
      # * response<~Fog::AWS::Response>:
      #   * body<~Hash>:
      #     * :delimeter<~String> - Delimiter specified for query
      #     * :marker<~String> - Marker specified for query
      #     * :max_keys<~Integer> - Maximum number of keys specified for query
      #     * :name<~String> - Name of the bucket
      #     * :prefix<~String> - Prefix specified for query
      #     * :contents<~Array>:
      #       * :key<~String>: Name of object
      #       * :last_modified<~String>: Timestamp of last modification of object
      #       * :owner<~Hash>:
      #         * :display_name<~String> - Display name of object owner
      #         * :id<~String> - Id of object owner
      #       * :size<~Integer> - Size of object
      #       * :storage_class<~String> - Storage class of object
      def get_bucket(bucket_name, options = {})
        options['max-keys'] = options.delete(:maxkeys) if options[:maxkeys]
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
