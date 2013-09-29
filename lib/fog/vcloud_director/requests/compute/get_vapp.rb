module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a vApp or VM.
        #
        # @param [String] vapp_id ID of the vApp or VM to retrieve.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VApp.html
        #   vCloud API Documentation
        def get_vapp(vapp_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vapp_id}"
          )
        end
      end
    end
  end
end
