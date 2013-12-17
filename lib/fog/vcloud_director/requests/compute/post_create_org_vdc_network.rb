module Fog
  module Compute
    class VcloudDirector
      class Real

        require 'fog/vcloud_director/generators/compute/org_vdc_network'

        # Create an Org vDC network.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # Produce media type(s):
        # application/vnd.vmware.vcloud.orgVdcNetwork+xml
        # Output type:
        # OrgVdcNetworkType
        #
        # @param [String] vdc_id Object identifier of the vDC
        # @param [String] name   The name of the entity.
        # @param [Hash] options
        # @option options [String] :Description Optional description.
        # @option options [Hash] :Configuration Network configuration.
        # @option options [Hash] :EdgeGateway  EdgeGateway that connects this 
        #   Org vDC network. Applicable only for routed networks.
        # @option options [Hash] :ServiceConfig Specifies the service 
        #   configuration for an isolated Org vDC networks.
        # @option options [Boolean] :IsShared True if this network is shared 
        #   to multiple Org vDCs.
        #   * :Configuration<~Hash>: NetworkConfigurationType
        #     * :IpScopes<~Hash>:
        #       * :IpScope<~Hash>:
        #         * :IsInherited<~Boolean>: ?
        #         * :Gateway<~String>: IP address of gw
        #         * :Netmask<~String>: Subnet mask of network
        #         * :Dns1<~String>: Primary DNS server.
        #         * :Dns2<~String>: Secondary DNS server.
        #         * :DnsSuffix<~String>: DNS suffix.
        #         * :IsEnabled<~String>: Indicates if subnet is enabled or not.
        #                                Default value is True.
        #         * :IpRanges<~Array>: IP ranges used for static pool allocation
        #                             in the network. Array of Hashes of:
        #                               * :StartAddress - start IP in range
        #                               * :EndAddress - end IP in range
        #   * :EdgeGateway<~Hash>: EdgeGateway that connects this Org vDC
        #                          network. Applicable only for routed networks.
        #   * :ServiceConfig<~Hash>: Specifies the service configuration for an
        #                            isolated network
        #
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CreateOrgVdcNetwork.html
        # @since vCloud API version 5.1
        def post_create_org_vdc_network(vdc_id, name, options={})

          body = Fog::Generators::Compute::VcloudDirector::OrgVdcNetwork.new(options.merge(:name => name)).generate_xml

          request(
            :body    => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.orgVdcNetwork+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "admin/vdc/#{vdc_id}/networks"
          )

        end
      end

      class Mock

        def post_create_org_vdc_network(vdc_id, name, options={})
          unless data[:vdcs][vdc_id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.vdc:#{vdc_id})\"."
            )
          end

        end
      end
    end
  end
end
