module Fog
  module Compute
    class HPV2
      class Real
        # Delete a keypair
        #
        # ==== Parameters
        # * 'key_name'<~String> - Name of the keypair to delete
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
            response
          else
            raise Fog::Compute::HPV2::NotFound
          end
        end
      end
    end
  end
end
