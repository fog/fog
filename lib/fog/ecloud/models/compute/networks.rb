require 'fog/ecloud/models/compute/network'

module Fog
  module Compute
    class Ecloud
      class Networks < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::Network

        def all
          data = connection.get_networks(href).body
          data = data[:Networks] ? data[:Networks][:Network] : data[:Network]
          data = data.nil? ? [] : data
          load(data)
        end

        def get(uri)
          if data = connection.get_network(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
