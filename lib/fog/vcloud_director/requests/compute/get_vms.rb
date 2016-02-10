module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vms'

        # Retrieve a vApp or VM.
        #
        # @note This should probably be deprecated.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see #get_vapp
        def get_vms(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::Vms.new,
            :path       => "vApp/#{id}"
          )
        end
      end
      class Mock
        def get_vms(id)
          vapp = get_vapp(id).body
          parser = Fog::Parsers::Compute::VcloudDirector::Vms.new
          vms  = vapp[:Children][:Vm].map {|child| parse_vapp_to_vm(child) }
          body = {:type => vapp[:type], :vms => vms}
          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :body => body
          )
        end
      end
    end
  end
end
