module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vms'

        # Retrieve a vApp or VM.
        #
        # @note This should probably be deprecated.
        # @param [String] vapp_id
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see #get_vapp
        def get_vms(vapp_id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::Vms.new,
            :path       => "vApp/#{vapp_id}"
          )
        end
      end
    end
  end
end
