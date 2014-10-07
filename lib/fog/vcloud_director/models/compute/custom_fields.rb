require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/custom_field'

module Fog
  module Compute
    class VcloudDirector

      class CustomFields < Collection
        model Fog::Compute::VcloudDirector::CustomField

        attribute :vapp

        def get_by_id(item_id)
          item_list.detect{|i| i[:id] == item_id}
        end

        def [](key)
          get key.to_s
        end

        def set(key, value, opts={:type => 'string', :password => 'false', :user_configurable => 'true'})
          new_items = item_list.each.reject{|item| item[:id] == key}
          new_items << {
            :id                => key,
            :value             => value,
            :type              => opts[:type],
            :password          => opts[:password],
            :user_configurable => opts[:user_configurable]
          }
          response = service.put_product_sections(vapp.id, new_items)
          service.process_task(response.body)
        end

        def []=(key,value)
          set(key,value)
        end

        def delete(item_id)
          id = item_id.to_s
          new_items = item_list.each.reject{|item| item[:id] == id}
          response = service.put_product_sections(vapp.id, new_items)
          service.process_task(response.body)
        end

        def item_list
          return @items if @items

          resp = service.get_product_sections_vapp(vapp.id).body

          collection = resp["ovf:ProductSection".to_sym]["ovf:Property".to_sym] rescue []
          collection = [collection] if collection.is_a?(Hash)

          @items = collection.collect do |property|
            {
              :id                => property[:ovf_key],
              :value             => property[:ovf_value],
              :type              => property[:ovf_type],
              :password          => property[:ovf_password],
              :user_configurable => property[:ovf_userConfigurable]
            }
          end rescue []
        end
      end

    end
  end
end
