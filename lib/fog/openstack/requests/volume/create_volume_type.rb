module Fog
  module Volume
    class OpenStack

      class Real
        def create_volume_type(name, options = {})
          data = {
            'volume_type' => {
              'name' => name,
            }
          }

          vanilla_options = [:extra_specs]
          vanilla_options.reject{ |o| options[o].nil? }.each do |key|
            data['volume_type'][key] = options[key]
          end

          request(
            :body    => MultiJson.encode(data),
            :expects => [200, 202],
            :method  => 'POST',
            :path    => 'types'
          )
        end
      end

      class Mock
        def create_volume_type(name, options = {})
          response = Excon::Response.new
          response.status = 202
          data = {
            'id'          => Fog::Mock.random_numbers(6).to_s,
            'name'        => name,
            'extra_specs' => options[:extra_specs],
          }
          self.data[:volume_types][data['id']] = data
          response.body = { 'volume_type' => data }
          response
        end
      end

    end
  end
end