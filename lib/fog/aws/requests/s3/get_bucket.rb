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
      def get_bucket(bucket_name, options = {})
        options['max-keys'] = options.delete(:maxkeys) if options[:maxkeys]
        query = '?'
        for key, value in options
          query << "#{key}=#{value};"
        end
        query.chop!
        request({
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
