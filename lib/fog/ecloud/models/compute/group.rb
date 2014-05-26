module Fog
  module Compute
    class Ecloud
      class Group < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :index, :aliases => :Index

        def servers
          @servers = Fog::Compute::Ecloud::Servers.new(:service => service, :href => href)
        end

        def edit(options = {})
          options[:uri] = href
          data = service.groups_edit(options).body
        end

        def move_up
          service.groups_moveup(href).body
        end

        def move_down
          service.groups_movedown(href).body
        end

        def delete
          service.groups_delete(href).body
        end

        def id
          href.scan(/\d+/)[0]
        end

        alias_method :destroy, :delete
      end
    end
  end
end
