module Fog
  module Compute
    class RackspaceV2
      class Real

        # Deletes the key specified with key_name
        #
        # ==== Parameters
        # * key_name<~String> - name of key to be deleted
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     *'success'<~Bool>: true or false for success
        def delete_keypair(key_name)
          request(
            :method   => 'DELETE',
            :expects  => 202,
            :path     => "/os-keypairs/#{key_name}"
          )
        end
      end

    end
  end
end
