require 'fog/core/model'

module Fog
  module Compute
    class Google
      class UrlMap < Fog::Model
        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :creationTimestamp, :aliases => 'creation_timestamp'
        attribute :defaultService, :aliases => 'default_service'
        attribute :description, :aliases => 'description'
        attribute :fingerprint, :aliases => 'fingerprint'
        attribute :hostRules, :aliases => 'host_rules'
        attribute :id, :aliases => 'id'
        attribute :pathMatchers, :aliases => 'path_matchers'
        attribute :self_link, :aliases => 'selfLink'
        attribute :tests, :aliases => 'tests'
      
        def save
          requires :name, :defaultService

          options = {
            'defaultService' => defaultService,
            'description' => description,
            'fingerprint' => fingerprint,
            'hostRules' => hostRules,
            'pathMatchers' => pathMatchers,
            'tests' => tests
          }
    
          data = service.insert_url_map(name, options).body
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data['name'])
          operation.wait_for { !pending? }
          reload
        end
      
        def destroy(async=true)
          requires :name

          operation = service.delete_url_map(name)
          if not async
            Fog.wait_for do
              operation = service.get_global_operation(operation.body["name"])
              operation.body["status"] == "DONE"
            end
          end
          operation
        end

        def validate
          service.validate_url_map self
        end
      
        def add_host_rules hostRules
          hostRules= [hostRules] unless hostRules.class == Array
          service.update_url_map(self, hostRules)
          reload
        end

        def add_path_matchers(pathMatchers, hostRules)
          pathMatchers = [pathMatchers] unless pathMatchers.class == Array
          hostRules=[hostRules] unless hostRules.class == Array
          service.update_url_map(self, hostRules, pathMatchers)
          reload
        end

        def ready?
          begin
            service.get_url_map(self.name)
            true
          rescue Fog::Errors::NotFound
            false
          end
        end

        def reload
          requires :name

          return unless data = begin
            collection.get(name)
          rescue Excon::Errors::SocketError
            nil
          end

          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end

        RUNNING_STATE ="READY"
      end
    end
  end
end
