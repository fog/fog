require 'fog/core/model'

module Fog
  module Compute
    class Google
      class TargetHttpProxy < Fog::Model
        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :self_link, :aliases => 'selfLink'
        attribute :id, :aliases => 'id'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description, :aliases => 'description'
        attribute :urlMap, :aliases => "urlMap"

        def save
          requires :name

          options = {
            'description' => description,
            'urlMap'      => urlMap
          }

          data = service.insert_target_http_proxy(name,  options).body
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data['name'], data['zone'])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async=true)
          requires :name
          operation = service.delete_target_http_proxy(name)
          if not async
            # wait until "DONE" to ensure the operation doesn't fail, raises
            # exception on error
            Fog.wait_for do
              operation.body["status"] == "DONE"
            end
          end
          operation
        end
        
        def set_url_map urlMap
          operation = service.set_target_http_proxy_url_map(self, urlMap)
          reload
        end

        def ready?
          begin
            service.get_target_http_proxy(self.name)
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

        RUNNING_STATE = "READY"
      end
    end
  end
end
