module Fog
  module AWS
    class S3

      # Get location constraint for an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to get location constraint for
      #
      # ==== Returns
      # FIXME: docs
      def get_bucket_location(bucket_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetBucketLocation.new,
          :query => 'location'
        })
      end

    end
  end
end
