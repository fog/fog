module Fog
  module Compute
    class Linode
      class Real

        # List all linodes user has access or delete to
        #
        # ==== Parameters
        # * linodeId<~Integer>: Limit the list to the specified LinodeID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def linode_list(linode_id=nil)
          options = {}
          if linode_id
            options.merge!(:linodeId => linode_id)
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.list' }.merge!(options)
          )
        end

      end
    end
  end
end
