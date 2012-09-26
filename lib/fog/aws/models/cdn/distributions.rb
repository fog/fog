require 'fog/core/collection'
require 'fog/aws/models/cdn/distribution'
require 'fog/aws/models/cdn/distributions_helper'

module Fog
  module CDN
    class AWS

      class Distributions < Fog::Collection
        include Fog::CDN::AWS::DistributionsHelper

        model Fog::CDN::AWS::Distribution

        attribute :marker,    :aliases => 'Marker'
        attribute :max_items, :aliases => 'MaxItems'
        attribute :is_truncated,    :aliases => 'IsTruncated'

        def get_distribution(dist_id)
          connection.get_distribution(dist_id)
        end

        def list_distributions(options = {})
          connection.get_distribution_list(options)
        end

        alias :each_distribution_this_page :each

      end

    end
  end
end
