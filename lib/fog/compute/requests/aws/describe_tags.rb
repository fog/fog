module Fog
  module AWS
    class Compute
      class Real

        require 'fog/compute/parsers/aws/describe_tags'

        # Describe all or specified tags
        #
        # ==== Parameters
        # * filters<~Hash> - List of filters to limit results with
        #
        # === Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'requestId'<~String> - Id of request
        #     * 'tagSet'<~Array>:
        #       * 'resourceId'<~String> - id of resource tag belongs to
        #       * 'resourceType'<~String> - type of resource tag belongs to
        #       * 'key'<~String> - Tag's key
        #       * 'value'<~String> - Tag's value
        def describe_tags(filters = {})
          params = AWS.indexed_filters(filters)
          request({
            'Action'    => 'DescribeTags',
            :idempotent => true,
            :parser     => Fog::Parsers::AWS::Compute::DescribeTags.new
          }.merge!(params))
        end

      end
    end
  end
end
