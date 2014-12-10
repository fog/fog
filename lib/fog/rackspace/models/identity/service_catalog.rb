require 'fog/core/model'

module Fog
  module Rackspace
    class Identity
      class ServiceCatalog < Fog::Model
        attr_reader :catalog

        def initialize(attributes)
          @service = attributes.delete(:service)
          @catalog = attributes.delete(:catalog) || {}
        end

        def services
          catalog.map {|s| s["name"]}
        end

        def get_endpoints(service_name, service_net=false)
          h = catalog.find {|service| service["name"] == service_name.to_s}
          return {} unless h
          key = network_type_key(service_net)
          h["endpoints"].select {|e| e[key]}
        end

        def display_service_regions(service_name, service_net=false)
          endpoints = get_endpoints(service_name, service_net)
          regions = endpoints.map do |e|
            e["region"] ? ":#{e["region"].downcase}" : ":global"
          end
          regions.join(", ")
        end

        def get_endpoint(service_name, region=nil, service_net=false)
          service_region = region_key(region)

          network_type = network_type_key(service_net)

          endpoints = get_endpoints(service_name, service_net)
          raise "Unable to locate endpoint for service #{service_name}" if endpoints.empty?

          if endpoints.size > 1 && region.nil?
            raise "There are multiple endpoints available for #{service_name}. Please specify one of the following regions: #{display_service_regions(service_name)}."
          end

          # select multiple endpoints
          endpoint = endpoints.find {|e| matching_region?(e, service_region) }
          return endpoint[network_type] if endpoint && endpoint[network_type]

          # endpoint doesnt have region
          if endpoints.size == 1 && matching_region?(endpoints[0], "GLOBAL")
            return endpoints[0][network_type]
          end

          raise "Unknown region :#{region} for service #{service_name}. Please use one of the following regions: #{display_service_regions(service_name)}"
        end

        def reload
          @service.authenticate
          @catalog = @service.service_catalog.catalog
          self
        end

        def self.from_response(service, hash)
          ServiceCatalog.new :service => service, :catalog => hash["access"]["serviceCatalog"]
        end

        private

        def network_type_key(service_net)
          service_net ? "internalURL" : "publicURL"
        end

        def matching_region?(h, region)
          region_key(h["region"]) == region
        end

        def region_key(region)
          return region.to_s.upcase if region.is_a? Symbol
          (region.nil? || region.empty?) ? "GLOBAL" : region.to_s.upcase
        end
      end
    end
  end
end
