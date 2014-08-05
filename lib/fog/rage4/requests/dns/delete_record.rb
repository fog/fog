module Fog
  module DNS
    class Rage4
      class Real
        # Delete a specific record
        # ==== Parameters
        # * id<~Integer> - numeric record ID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>
        def delete_record(id)
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/deleterecord/#{id}" )
        end
      end
    end
  end
end
