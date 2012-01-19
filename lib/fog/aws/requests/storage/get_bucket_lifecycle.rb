module Fog
  module Storage
    class AWS
      class Real

        require 'fog/aws/parsers/storage/get_bucket_lifecycle'

        # Get bucket lifecycle configuration
        #
        # ==== Parameters
        # * bucket_name<~String> - name of bucket to get lifecycle configuration for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Rules'<~Array> - object expire rules
        #        * 'ID'<~String>      - Unique identifier for the rule
        #        * 'Prefix'<~String>  - Prefix identifying one or more objects to which the rule applies
        #        * 'Enabled'<~Boolean> - if rule is currently being applied
        #        * 'Days'<~Integer>   - lifetime, in days, of the objects that are subject to the rule
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGETlifecycle.html

        def get_bucket_lifecycle(bucket_name)
          request({
                    :expects  => 200,
                    :headers  => {},
                    :host     => "#{bucket_name}.#{@host}",
                    :idempotent => true,
                    :method   => 'GET',
                    :parser   => Fog::Parsers::Storage::AWS::GetBucketLifecycle.new,
                    :query    => {'lifecycle' => nil}
                  })
        end

      end
    end
  end
end

