module Fog
  module Storage
    class HP
      class Real
        # Delete an existing container
        #
        # ==== Parameters
        # * name<~String> - Name of container to delete
        #
        def delete_container(name)
          response = request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => Fog::HP.escape(name)
          )
          response
        end
      end

      class Mock # :nodoc:all
        def delete_container(container_name)
          response = Excon::Response.new
          if self.data[:containers][container_name].nil?
            response.status = 404
            raise Fog::Storage::HP::NotFound
          elsif self.data[:containers][container_name] && !self.data[:containers][container_name][:objects].empty?
            response.status = 409
            raise(Excon::Errors.status_error({:expects => 204}, response))
          else
            self.data[:containers].delete(container_name)
            response.status = 204
          end
          response
        end
      end
    end
  end
end
