module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a vApp or VM.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VApp.html
        # @since vCloud API version 0.9
        def get_vapp(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}"
          )
          ensure_list! response.body, :Children, :Vm
          response
        end
      end
    end
  end
end
