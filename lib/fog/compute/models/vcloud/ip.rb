module Fog
  module Vcloud
    class Compute
      class Ip < Fog::Vcloud::Model

        ignore_attributes :xmlns_i, :xmlns

        identity :href, :aliases => :Href

        attribute :name, :aliases => :Name
        attribute :status, :aliases => :Status
        attribute :server, :aliases => :Server
        attribute :id, :aliases => :Id, :type => :integer

        def save
          if @changed
            connection.configure_network_ip( href, _compose_network_ip_data )
          end
          true
        end

        def reload
          super
          @changed = false
          self
        end

        private
        def _compose_network_ip_data
          {
            :id => id,
            :href => href,
            :name => name,
            :status => status,
            :server => server
          }
        end

      end
    end
  end
end
