module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the network config section of a vApp.
        #
        # @param [String] id The object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-NetworkConfigSection-vApp.html
        # @since vCloud API version 0.9
        def get_network_config_section_vapp(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/networkConfigSection/"
          )
        end
      end
    end
  end
end
