require 'fog/core/collection'
require 'fog/hp/models/compute_v2/server'

module Fog
  module Compute
    class HPV2

      class Servers < Fog::Collection

        model Fog::Compute::HPV2::Server

        def all(options = {})
          data = service.list_servers_detail(options).body['servers']
          load(data)
        end

        # Creates a new server and populates ssh keys
        # service.servers.bootstrap :name => 'my-server',
        #                           :flavor_id => service.flavors.first.id,
        #                           :image_id => service.images.find {|img| img.name =~ /Ubuntu/}.id,
        #                           :public_key_path => '~/.ssh/my_public_key.pub',
        #                           :private_key_path => '~/.ssh/my_private_key'
        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready?  && !public_ip_address.empty?}
          server.setup(:password => server.password)
          server
        end

        def get(server_id)
          if server = service.get_server_details(server_id).body['server']
            new(server)
          end
        rescue Fog::Compute::HPV2::NotFound
          nil
        end

      end

    end
  end
end
