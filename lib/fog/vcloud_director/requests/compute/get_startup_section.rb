module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the startup section of a vApp.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-StartupSection.html
        # @since vCloud API version 0.9
        def get_startup_section(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/startupSection"
          )
        end
      end
    end
  end
end
