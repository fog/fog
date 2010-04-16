module Fog
  module Terremark
    module Shared
      module Real

        # Shutdown a vapp
        #
        # ==== Parameters
        # * vapp_id<~Integer> - Id of vapp to shutdown
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'endTime'<~String> - endTime of task
        #     * 'href'<~String> - link to task
        #     * 'startTime'<~String> - startTime of task
        #     * 'status'<~String> - status of task
        #     * 'type'<~String> - type of task
        #     * 'Owner'<~String> -
        #       * 'href'<~String> - href of owner
        #       * 'name'<~String> - name of owner
        #       * 'type'<~String> - type of owner
        def shutdown(vapp_id)
          request(
            :expects  => 202,
            :method   => 'POST',
            :parser   => Fog::Parsers::Terremark::Shared::Task.new,
            :path     => "vApp/#{vapp_id}/power/action/shutdown"
          )
        end

      end

      module Mock

        def shutdown(vapp_id)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
