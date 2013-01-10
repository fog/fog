module Fog
  module Compute
    class RackspaceV2
      class Real
        def update_server(server_id, options={})
          data = options.is_a?(Hash) ? options : { 'name' => options } #LEGACY - second parameter was previously server name

          request(
            :body => Fog::JSON.encode('server' => data),
            :expects => [200],
            :method => 'PUT',
            :path => "servers/#{server_id}"
          )
        end
      end
    end
  end
end
