module Fog
  module Compute
    class VcloudDirector
      class Real
        # Take the vApp out of maintenance mode.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-ExitMaintenanceMode.html
        # @since vCloud API version 1.5
        def post_exit_maintenance_mode(id)
          request(
            :expects => 204,
            :method  => 'POST',
            :path    => "vApp/#{id}/action/exitMaintenanceMode"
          )
        end
      end
    end
  end
end
