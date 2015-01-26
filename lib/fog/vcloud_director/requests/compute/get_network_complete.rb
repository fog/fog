module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve an organization network.
        #
        # @param [String] id Object identifier of the network.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Network.html
        # @since vCloud API version 0.9
        def get_network_complete(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "admin/network/#{id}"
          )
          ensure_list! response.body[:Configuration][:IpScopes][:IpScope], :IpRanges, :IpRange
          response
        end
      end

      class Mock
        def get_network_complete(id)
          unless network = data[:networks][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          body = {
            :name => network[:name],
            :href => make_href("network/#{id}"),
            :type => "application/vnd.vmware.vcloud.orgNetwork+xml",
            :id   => id,
            :Description => network[:Description],
            :Configuration => {
              :IpScopes => {
                :IpScope => {
                  :IsInherited => network[:IsInherited].to_s,
                  :Gateway     => network[:Gateway],
                  :Netmask     => network[:Netmask],
                  :Dns1        => network[:Dns1],
                  :Dns2        => network[:Dns2],
                  :DnsSuffix   => network[:DnsSuffix],
                  :IsEnabled   => true.to_s,
                  :IpRanges    => {
                    :IpRange => [],
                  },
                }
              },
              :FenceMode => network[:FenceMode],
              :RetainNetInfoAcrossDeployments => false.to_s,
            },
            :IsShared => network[:IsShared].to_s,
          }

          body[:Configuration][:IpScopes][:IpScope][:IpRanges][:IpRange] =
            network[:IpRanges].map do |ip_range|
              {:StartAddress => ip_range[:StartAddress],
               :EndAddress   => ip_range[:EndAddress]}
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
