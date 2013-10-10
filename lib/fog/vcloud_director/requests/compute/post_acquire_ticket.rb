module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a screen ticket that you can use with the VMRC browser
        # plug-in to gain access to the console of a running VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raises Excon::Errors::Conflict
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-AcquireTicket.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def post_acquire_ticket(id)
          request(
            :expects => 200,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/screen/action/acquireTicket"
          )
        end
      end
    end
  end
end
