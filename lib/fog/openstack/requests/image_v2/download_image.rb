module Fog
  module Image
    class OpenStack
      class V2
        class Real
          def download_image(image_id, content_range=nil, params) # TODO: implement content range handling
            request_hash = {
              :expects  => [200, 204],
              :method   => 'GET',
              :raw_body => true,
              :path     => "images/#{image_id}/file",
            }
            request_hash[:headers]        = {"Range" => content_range} if content_range
            request_hash[:response_block] = params[:response_block] if params[:response_block]

            return_header = params.delete(:return_header)
            if return_header
              # Header contains e.g a checksum that is useful
              response = request(request_hash)
              return response.body, response.headers
            else
              request(request_hash).body
            end
          end
        end # class Real

        class Mock
          def download_image(image_id, content_range=nil)
            response = Excon::Response.new
            response.status = [200, 204][rand(1)]
            response.body = ""
            response
          end # def list_tenants
        end # class Mock
      end # class OpenStack
    end
  end # module Identity
end # module Fog
