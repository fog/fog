require 'fog/core/collection'
require 'fog/aws/models/cdn/streaming_distribution'
require 'fog/aws/models/cdn/distributions_helper'

module Fog
  module CDN
    class AWS

      class StreamingDistributions < Fog::Collection
        include Fog::CDN::AWS::DistributionsHelper

        model Fog::CDN::AWS::StreamingDistribution

        attribute :marker,    :aliases => 'Marker'
        attribute :max_items, :aliases => 'MaxItems'
        attribute :is_truncated,    :aliases => 'IsTruncated'

        def get_distribution(dist_id)
          service.get_streaming_distribution(dist_id)
        end

        def list_distributions(options = {})
          service.get_streaming_distribution_list(options)
        end

        alias :each_distribution_this_page :each

      end

    end
  end
end
