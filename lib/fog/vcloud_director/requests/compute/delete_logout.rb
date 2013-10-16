module Fog
  module Compute
    class VcloudDirector
      class Real
        # @return [Excon::Response]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-Logout.html
        def delete_logout
          request(
            :expects => 204,
            :method  => 'DELETE',
            :path    => 'session'
          )
        end
      end
    end
  end
end
