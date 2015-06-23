require 'fog/core/collection'
require 'fog/openstack/models/baremetal/chassis'

module Fog
  module Baremetal
    class OpenStack
      class ChassisCollection < Fog::Collection
        model Fog::Baremetal::OpenStack::Chassis

        def all(options = {})
          load(service.list_chassis_detailed(options).body['chassis'])
        end

        def summary(options = {})
          load(service.list_chassis(options).body['chassis'])
        end

        def details(options = {})
          Fog::Logger.deprecation("Calling OpenStack[:baremetal].chassis_collection.details will be removed, "\
                                  " call .chassis_collection.all for detailed list.")
          load(service.list_chassis_detailed(options).body['chassis'])
        end

        def find_by_uuid(uuid)
          new(service.get_chassis(uuid).body)
        end
        alias_method :get, :find_by_uuid

        def destroy(uuid)
          chassis = self.find_by_id(uuid)
          chassis.destroy
        end

        def method_missing(method_sym, *arguments, &block)
          if method_sym.to_s =~ /^find_by_(.*)$/
            load(service.list_chassis_detailed({$1 => arguments.first}).body['chassis'])
          else
            super
          end
        end
      end
    end
  end
end
