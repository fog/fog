module Fog
  module Compute
    class Vcloudng
      class Real

        
        require 'fog/vcloudng/parsers/compute/get_network'


        # Get details for a Network
        #
        # ==== Parameters
        # * network_id<~String> - Id of the network to look up
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   
        # ==== How to get the catalog_uuid?
        #
        # org_uuid = vcloud.get_organizations.data[:body]["OrgList"].first["href"].split('/').last
        # org = vcloud.get_organization(org_uuid)
        #
        # network_id = org.data[:body]["Links"].detect {|l| l["type"] =~ /vcloud.orgNetwork/ }["href"].split('/').last
        def get_network(network_id)
         request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser   => Fog::Parsers::Compute::Vcloudng::GetNetwork.new,
            :path     => "network/#{network_id}"
          )
        end
        
        def network_end_point(network_id = nil)
          end_point + ( network_id ? "network/#{network_id}" : "network" )
        end

      end
    end
  end
end
      