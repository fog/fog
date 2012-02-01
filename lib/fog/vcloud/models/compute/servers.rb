require 'fog/vcloud/models/compute/server'

module Fog
  module Vcloud
    class Compute

      class Servers < Fog::Vcloud::Collection

        undef_method :create

        model Fog::Vcloud::Compute::Server

        attribute :href, :aliases => :Href

        def all
          check_href!("Vapp")
          vapp.load_unless_loaded!
          load(vapp.children||[])
        end

        def get(uri)
          connection.get_vapp(uri)
        rescue Fog::Errors::NotFound
          nil
        end

        def create options
          check_href!
          options[:vdc_uri] = href
          data = connection.instantiate_vapp_template(options).body
          object = new(data)
          object
        end

        private

        def vapp
          @vapp ||= (attributes[:vapp] || init_vapp)
        end

        def init_vapp
          Fog::Vcloud::Compute::Vapp.new(
            :connection => connection,
            :href => self.href,
            :collection => Fog::Vcloud::Compute::Vapps.new(:connection => connection)
          )
        end

      end
    end
  end
end
