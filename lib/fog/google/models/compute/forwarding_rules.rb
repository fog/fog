require 'fog/core/collection'
require 'fog/google/models/compute/forwarding_rule'

module Fog
  module Compute
    class Google
      class ForwardingRules < Fog::Collection
        model Fog::Compute::Google::ForwardingRule

        def all(filters={})
          if filters['region'].nil?
            data = []
            service.list_regions.body['items'].each do |region|
              data += service.list_forwarding_rules(region['name']).body['items'] || []
            end
          else
            data = service.list_forwarding_rules(filters['region']).body['items'] || []
          end
          load(data)
        end

        def get(identity, region=nil)
          response = nil
          if region.nil?
            service.list_regions.body['items'].each do |region|
              begin
                response = service.get_forwarding_rule(identity, region['name'])
                break if response.status == 200
              rescue Fog::Errors::Error
              end
            end
          else
            response = service.get_forwarding_rule(identity, region)
          end
          return nil if response.nil?
          new(response.body)
        end
      end
    end
  end
end
