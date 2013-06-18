module Fog
  module Compute
    class Vcloudng
      class Real


        require 'fog/vcloudng/parsers/compute/get_vapp'


        # Get details of a vapp
        #
        # ==== Parameters
        # * vapp_id<~Integer> - Id of vapp to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:

        # FIXME

        #     * 'endTime'<~String> - endTime of task
        #     * 'href'<~String> - link to task
        #     * 'startTime'<~String> - startTime of task
        #     * 'status'<~String> - status of task
        #     * 'type'<~String> - type of task
        #     * 'Owner'<~String> -
        #       * 'href'<~String> - href of owner
        #       * 'name'<~String> - name of owner
        #       * 'type'<~String> - type of owner
        #     * 'Result'<~String> -
        #       * 'href'<~String> - href of result
        #       * 'name'<~String> - name of result
        #       * 'type'<~String> - type of result
        def get_vapp(vapp_id)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser   => Fog::Parsers::Compute::Vcloudng::GetVapp.new,
            :path     => "vApp/#{vapp_id}"
          )
        end

      end
    end
  end
end
