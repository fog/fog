module Fog
  module CDN
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
        def delete_container(name)
          response = Excon::Response.new
          if self.data[:cdn_containers][name]
            self.data[:cdn_containers].delete(name)
            response.status = 204
            response.body = ""
            response
          else
            raise Fog::CDN::HP::NotFound
          end
        end
      end
    end
  end
end
