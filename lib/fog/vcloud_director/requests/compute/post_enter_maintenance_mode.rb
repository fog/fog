module Fog
  module Compute
    class VcloudDirector
      class Real
        # Place the vApp in maintenance mode.
        #
        # When a vApp is in maintenance mode, it is read-only to users. Only a
        # system administrator can modify it. User-initiated tasks that are
        # running when the vApp enters maintenance mode continue to run.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-EnterMaintenanceMode.html
        # @since vCloud API version 1.5
        def post_enter_maintenance_mode(id)
          request(
            :expects => 204,
            :method  => 'POST',
            :path    => "vApp/#{id}/action/enterMaintenanceMode"
          )
        end
      end
    end
  end
end
