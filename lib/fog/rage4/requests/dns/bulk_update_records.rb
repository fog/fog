module Fog
  module DNS
    class Rage4
      class Real
        # Updates existing records in bulk
        # ==== Parameters
        # * zone_id <~Integer> Need to specify the zone id
        # * options <~Hash> Options should contain the body for the post
        #                   in the following format.
        #                   data = [{:id=><record_id>, :priority=>2}, {:id=><record_id>, :priority=>2}]
        #                   options => { :body => data.to_json }
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>

# https://secure.rage4.com//rapi/SetRecordState/<zone_id>/

        def bulk_update_records(zone_id, options = {})
          path = "/rapi/SetRecordState/#{zone_id}"
          body = options[:body] if options[:body].present?

          request(
                  :expects  => 200,
                  :method   => 'POST',
                  :body     => body,
                  :path     => path,
                  :headers => {
                    'Content-Type' => "application/json; charset=UTF-8",
                  },
          )
        end
      end
    end
  end
end
