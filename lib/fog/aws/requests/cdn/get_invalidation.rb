module Fog
  module CDN
    class AWS
      class Real

        require 'fog/aws/parsers/cdn/get_invalidation'

        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'Id'<~String> - Invalidation id
        #     * 'Status'<~String>
        #     * 'CreateTime'<~String>
        #     * 'InvalidationBatch'<~Array>:
        #       * 'Path'<~String>
        # ==== See Also
        # http://docs.amazonwebservices.com/AmazonCloudFront/2010-11-01/APIReference/GetInvalidation.html

        def get_invalidation(distribution_id, invalidation_id)
          request({
            :expects    => 200,
            :idempotent => true,
            :method   => 'GET',
            :parser   => Fog::Parsers::CDN::AWS::GetInvalidation.new,
            :path       => "/distribution/#{distribution_id}/invalidation/#{invalidation_id}"
          })
        end

      end
    end
  end
end
