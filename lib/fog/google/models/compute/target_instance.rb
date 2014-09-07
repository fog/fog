require 'fog/core/model'

module Fog
  module Compute
    class Google
      class TargetInstance < Fog::Model
        identity :name

        attribute :kind, :aliases => 'kind'
        attribute :self_link, :aliases => 'selfLink'
        attribute :id, :aliases => 'id'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description, :aliases => 'description'
        attribute :zone, :aliases => "zone"
        attribute :instance, :aliases => "instance"
        attribute :nat_policy, :aliases => "natPolicy"

        def save
          requires :name, :zone

          options = {
            'description' => description,
            'zone' => zone,
            'natPolicy' => nat_policy,
            'instance' => instance,
          }

          data = service.insert_target_instance(name, zone, options).body
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data['name'])
          operation.wait_for { !pending? }
          reload
        end

        def destroy(async=true)
          requires :name, :zone
          operation = service.delete_target_instance(name, zone)
          if not async
            # wait until "DONE" to ensure the operation doesn't fail, raises
            # exception on error
            Fog.wait_for do
              operation.body["status"] == "DONE"
            end
          end
          operation
        end

        def ready?
          begin
            service.get_target_instance(self.name, self.zone)
            true
          rescue Fog::Errors::NotFound
            false
          end
        end

        def reload
          requires :name, :zone

          return unless data = begin
            collection.get(name, zone)
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
