require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/tag'

module Fog
  module Compute
    class VcloudDirector

      class CustomFields < Collection
        model Fog::Compute::VcloudDirector::CustomField

        attribute :vapp

        def get_by_id(item_id)
          item_list.detect{|i| i[:id] == item_id}
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
          service.put_product_sections_vapp(vapp.id, new_items)
        end

        def delete(item_id)
          new_items = item_list.each.reject{|item| item[:id] == item_id}
          service.put_product_sections_vapp(vapp.id, new_items)
        end

        def item_list
          return @items if @items

          resp = service.get_product_sections_vapp(vapp.id).body
          @items = resp["ovf:ProductSection".to_sym]["ovf:Property".to_sym].collect do |property|
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
