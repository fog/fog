module Fog
  module DNS
    class Rage4
      class Real
        # List all the record types available
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'record types'<~Hash>
        #       *'name' <~String> record type name
        #       *'value' <~Integer> Integer value of the type
        def list_record_types
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => '/rapi/listrecordtypes'
                  )
        end
      end
    end
  end
end
