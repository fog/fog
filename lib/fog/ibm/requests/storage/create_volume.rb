module Fog
  module Storage
    class IBM
      class Real

        # Create a volume
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def create_volume(name, offering_id, format, location, size, extra_params={})
          options = {
            :method   => 'POST',
            :expects  => 200,
            :path     => '/storage',
          }
          params = {
            'name' => name,
            'offeringID' => offering_id,
            'format' => format,
            'location' => location,
            'size' => size
          }
          options.merge!(form_body(params.merge(extra_params)))
          request(options)
        end

      end
    end
  end
end
