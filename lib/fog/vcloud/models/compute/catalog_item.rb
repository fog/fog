module Fog
  module Vcloud
    class Compute
      class CatalogItem < Fog::Vcloud::Model
        identity :href, :aliases => :Href
        attribute :links, :aliases => :Link, :type => :array
        ignore_attributes :xmlns, :xmlns_i, :xmlns_xsi, :xmlns_xsd

        attribute :type
        attribute :name
        attribute :entity, :aliases => :Entity
        attribute :link, :aliases => :Link
        attribute :property, :aliases => :Property

        def customization_options
          load_unless_loaded!
          if data = service.get_customization_options( link[:href] ).body
            data.delete_if { |key, value| [:xmlns_i, :xmlns].include?(key) }
            data
          else
            nil
          end
        end

        def password_enabled?
          load_unless_loaded!
          customization_options = service.get_vapp_template(self.entity[:href]).body[:Children][:Vm][:GuestCustomizationSection]
          return false if customization_options[:AdminPasswordEnabled] == "false"
          return true if customization_options[:AdminPasswordEnabled] == "true" \
            and customization_options[:AdminPasswordAuto] == "false" \
            and ( options[:password].nil? or options[:password].empty? )
        end
      end
    end
  end
end
