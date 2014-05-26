module Fog
  module Compute
    class HP
      class Real
        # Delete a keypair
        #
        # ==== Parameters
        # * key_name<~String> - Name of the keypair to delete
        #
        def delete_key_pair(key_name)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "os-keypairs/#{key_name}"
          )
        end
      end

      class Mock
        def delete_key_pair(key_name)
          response = Excon::Response.new
          if self.data[:key_pairs][key_name]
            self.data[:last_modified][:key_pairs].delete(key_name)
            self.data[:key_pairs].delete(key_name)
            response.status = 202
            response.body = "202 Accepted\n\nThe request is accepted for processing.\n\n   "
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
