module Fog
  module Compute
    class Serverlove < Fog::Service
            
      requires :serverlove_uuid, :serverlove_api_key
      
      recognizes :serverlove_api_url
      
      request_path 'fog/serverlove/requests/compute'
      request :get_drives
      
      class Mock
        
        def initialize(options)
          @serverlove_uuid = options[:serverlove_uuid] || Fog.credentials[:serverlove_uuid]
          @serverlove_api_key = options[:serverlove_api_key] || Fog.credentials[:serverlove_api_key]
        end
        
        def request(options)
          raise "Not implemented"
        end
        
      end
      
      class Real
        
        def initialize(options)
          @api_uuid = options[:serverlove_uuid] || Fog.credentials[:serverlove_uuid]
          @api_key = options[:serverlove_api_key] || Fog.credentials[:serverlove_api_key]
          
          @connection = Fog::Connection.new("https://#{@api_uuid}:#{@api_key}@api.z1-man.serverlove.com/")
        end
        
        def request(params)
          params = params.merge!(
            :headers => {
              "Content-Type" => "application/json"
            }
          )
          response = @connection.request(params)
          
          raise_if_error!(response)
          
          response.body = Fog::JSON.decode(response.body)
          
          response
        end
        
        
        def raise_if_error!(response)
          case response.status
          when 400 then 
            raise 'omg'
          end
        end
        
      end
            
    end
  end
end