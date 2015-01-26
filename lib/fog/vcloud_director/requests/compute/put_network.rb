module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/org_vdc_network'

        # Update an Org vDC network.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # Produce media type(s):
        # application/vnd.vmware.vcloud.orgVdcNetwork+xml
        # Output type:
        # TaskType
        #
        # @param [String] id Object identifier of the network
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
        def put_network(id, name, options={})
          body = Fog::Generators::Compute::VcloudDirector::OrgVdcNetwork.new(options.merge(:name => name)).generate_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.orgVdcNetwork+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "admin/network/#{id}"
          )
        end
      end

      class Mock
        def put_network(id, name, options={})
          original_network = data[:networks][id]
          unless original_network
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"(com.vmware.vcloud.entity.orgVdcNetwork:#{id})\"."
            )
          end

          type = 'network'

          # Description
          # Configuration
          #   IpScopes
          #     IpScope
          #       IsInherited
          #       Gateway
          #       Netmask
          #       Dns1
          #       Dns2
          #       DnsSuffix
          #       IsEnabled
          #       IpRanges
          #         IpRange
          #           StartAddress
          #           EndAddress
          #   FenceMode
          # EdgeGateway
          # IsShared
          #
          vdc_id = original_network[:vdc],

          network_body = {
            :name => name,
            :vdc  => vdc_id,
          }

          [:Description, :IsShared].each do |key|
            network_body[key] = options[key] if options.key?(key)
          end

          if options.key?(:EdgeGateway)
            network_body[:EdgeGateway] =
              options[:EdgeGateway][:href].split('/').last
          end

          if configuration = options[:Configuration]
            if ip_scopes = configuration[:IpScopes]
              if ip_scope = ip_scopes[:IpScope]
                [:IsInherited, :Gateway, :Netmask,
                  :Dns1, :Dns2, :DnsSuffix, :IsEnabled].each do |key|
                    network_body[key] = ip_scope[key] if ip_scope.key?(key)
                end
                if ip_ranges = ip_scope[:IpRanges]
                  network_body[:IpRanges] = []
                  ip_ranges.each do |ipr|
                    network_body[:IpRanges] << {
                      :StartAddress => ipr[:IpRange][:StartAddress],
                      :EndAddress   => ipr[:IpRange][:EndAddress]
                    }
                  end
                end
              end
            end
            network_body[:FenceMode] = configuration[:FenceMode] if ip_scope.key?(:FenceMode)
          end

          owner = {
            :href => make_href("#{type}/#{id}"),
            :type => "application/vnd.vmware.vcloud.#{type}+xml"
          }
          task_id = enqueue_task(
            "Updating #{type} #{name} (#{id})", 'networkUpdateNetwork', owner,
            :on_success => lambda do
              data[:networks][id] = network_body
            end
          )
          task = task_body(task_id)
          task.delete(:Owner) #known-bug: admin-api does not return owner.
          body = {
              :xmlns => xmlns,
              :xmlns_xsi => xmlns_xsi,
              :xsi_schemaLocation => xsi_schema_location,
          }.merge(task)

          Excon::Response.new(
            :status => 202,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )

        end
      end
    end
  end
end
