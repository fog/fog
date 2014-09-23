module Fog
  module Rackspace
    class AutoScale
      class Real
        def delete_server(group_id, server_id, options={})
          request(
            :expects => [202],
            :method => 'DELETE',
            :path => "groups/#{group_id}/servers/#{server_id}?replace=#{options.fetch(:replace, true).to_s}"
          )
        end
      end

      class Mock
        def delete_server(group_id)
           response(:status => 202)
        end
      end
    end
  end
end
