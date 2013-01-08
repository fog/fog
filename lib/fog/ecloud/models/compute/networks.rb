require 'fog/ecloud/models/compute/network'

module Fog
  module Compute
    class Ecloud
      class Networks < Fog::Ecloud::Collection

        attribute :href, :aliases => :Href

        model Fog::Compute::Ecloud::Network

        def all
          body = service.get_networks(self.href).body
          body = body[:Networks] ? body[:Networks][:Network] : body[:Network]
          data = case body
                 when NilClass then []
                 when Array then body
                 when Hash then [body]
                 end
          load(data)
        end

        def get(uri)
          if data = service.get_network(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
