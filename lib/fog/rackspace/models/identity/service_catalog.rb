require 'fog/core/model'

module Fog
  module Rackspace
    class Identity
      class ServiceCatalog < Fog::Model
        attr_reader :catalog
        
        def initialize(attributes)
          @service = attributes.delete(:service)
          @catalog = {}
        end
        
        def services
          catalog.keys
        end
        
        def get_endpoints(service_type)
          service_type = service_type.is_a?(String) ? service_type.to_sym : service_type
          catalog[service_type]
        end
        
        def display_service_regions(service_type)
          endpoints = get_endpoints(service_type)
          endpoints.collect { |k,v| ":#{k}" }.join(", ")          
        end
        
        def get_endpoint(service_type, region=nil)
          endpoint = get_endpoints(service_type)
          raise "Unable to locate endpoint for service #{service_type}" unless endpoint

          return endpoint if endpoint.is_a?(String) #There is only one endpoint for service

          unless region
            raise "There are multiple endpoints avaliable for #{service_type}. Please specify one of the following regions: #{display_service_regions(service_type)}."
          end
          region = region.is_a?(String) ? region.to_sym : region
          endpoint = get_endpoints(service_type)[region]
          raise "Unknown region :#{region} for service #{service_type}. Please use one of the following regions: #{display_service_regions(service_type)}" unless endpoint
          endpoint
        end
        
        def reload
          @service.authenticate
          @catalog = @service.service_catalog.catalog
          self
        end
                
        def self.from_response(service, hash)
          service_catalog = ServiceCatalog.new :service => service
          services = hash["access"]["serviceCatalog"]
          services.each do |serv|
            name = serv["name"].to_sym
            service_catalog.send(:add_endpoints, name, serv)
          end
          service_catalog
        end

        private
        
        def add_endpoints(service_name, hash)
          endpoints = hash["endpoints"]
          if endpoints.size == 1
            catalog[service_name] = endpoints[0]["publicURL"].freeze
          else
            catalog[service_name] = endpoints_from_array(endpoints)
          end
        end
        
        def endpoints_from_array(endpoints)
          hash = {}
          endpoints.each do |endpoint|
            region = endpoint["region"].downcase.to_sym
            url = endpoint["publicURL"].freeze
            hash[region] = url
          end
          hash
        end
        
      end
    end
  end
end