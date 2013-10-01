module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/network'

        # Retrieve an organization network.
        #
        # @param [String] network_id Object identifier of the network.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Network.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def get_network(network_id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::Network.new,
            :path       => "network/#{network_id}"
          )
        end
      end

      class Mock
        def get_network(network_id)
          response = Excon::Response.new

          unless valid_uuid?(network_id)
            response.status = 400
            raise Excon::Errors.status_error({:expect => 200}, response)
          end
          unless network = data[:networks][network_id]
            response.status = 403
            raise Excon::Errors.status_error({:expect => 200}, response)
          end

          body =
            {:name=>network[:name],
             :href=>make_href("network/#{network_id}"),
             :type=>"application/vnd.vmware.vcloud.orgNetwork+xml",
             :id=>network_id,
             :description=>nil,
             :is_inherited=>network[:IsInherited],
             :gateway=>network[:Gateway],
             :netmask=>network[:Netmask],
             :dns1=>network[:Dns1],
             :dns2=>network[:Dns2],
             :dns_suffix=>network[:DnsSuffix]}

          body[:ip_ranges] = network[:IpRanges].map do |ip_range|
            {:start_address=>ip_range[:StartAddress],
             :end_address=>ip_range[:EndAddress]}
          end

          response.status = 200
          response.headers = {'Content-Type' => "#{body[:type]};version=#{api_version}"}
          response.body = body
          response
        end
      end
    end
  end
end
