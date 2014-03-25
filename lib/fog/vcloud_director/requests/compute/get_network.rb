module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/network'

        # Retrieve an organization network.
        #
        # @deprecated Use {#get_network_complete} instead
        #
        # @param [String] id Object identifier of the network.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Network.html
        # @since vCloud API version 0.9
        def get_network(id)
          Fog::Logger.deprecation("#{self} => #get_network is deprecated, use #get_network_complete instead [light_black](#{caller.first})[/]")
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::Network.new,
            :path       => "network/#{id}"
          )
        end
      end

      class Mock
        def get_network(id)
          Fog::Logger.deprecation("#{self} => #get_network is deprecated, use #get_network_complete instead [light_black](#{caller.first})[/]")
          unless network = data[:networks][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          body =
            {:name=>network[:name],
             :href=>make_href("network/#{id}"),
             :type=>"application/vnd.vmware.vcloud.orgNetwork+xml",
             :id=>id,
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

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
