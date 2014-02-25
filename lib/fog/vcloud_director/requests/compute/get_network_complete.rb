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

          Fog::Mock.not_implemented

        end
      end
    end
  end
end
