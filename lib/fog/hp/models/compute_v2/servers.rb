require 'fog/core/collection'
require 'fog/hp/models/compute_v2/server'

module Fog
  module Compute
    class HPV2
      class Servers < Fog::Collection
        attribute :filters

        model Fog::Compute::HPV2::Server

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          details = filters_arg.delete(:details)
          filters = filters_arg
          non_aliased_filters = Fog::HP.convert_aliased_attributes_to_original(self.model, filters)
          if details
            data = service.list_servers_detail(non_aliased_filters).body['servers']
          else
            data = service.list_servers(non_aliased_filters).body['servers']
          end
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
