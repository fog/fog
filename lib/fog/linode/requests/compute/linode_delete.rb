module Fog
  module Compute
    class Linode
      class Real

        # List all linodes user has access or delete to
        #
        # ==== Parameters
        # * linode_id<~Integer>: id of linode to delete
        # * options<~Hash>:
        #   * skipChecks<~Boolean>: skips safety checks and always deletes
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def linode_delete(linode_id, options={})
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.delete', :linodeId => linode_id }.merge!(options)
          )
        end

      end
    end
  end
end
