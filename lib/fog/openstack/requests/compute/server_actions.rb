module Fog
  module Compute
    class OpenStack
      class Real
        # Retrieve server actions.
        #
        # === Parameters
        # * server_id <~String> - The ID of the server to query for available actions.
        # === Returns
        # * actions <~Array>
        def server_actions(server_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "servers/#{server_id}/actions"
          ).body['actions']
        end # def server_actions
      end # class Real

      class Mock
        def server_actions(server_id)
          Array.new
        end # def server_actions
      end # class Mock
    end # class OpenStack
  end # module Compute
end # moduel Fog
