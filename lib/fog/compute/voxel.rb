module Fog
  module Voxel
    class Compute < Fog::Service

      requires :voxel_api_key, :voxel_api_secret

      model_path 'fog/compute/models/voxel'
      model       :image
      collection  :images
      model       :server
      collection  :servers

      request_path 'fog/compute/requests/voxel'
      request :images_list
      request :devices_list

      class Mock
        include Collections
      end

      class Real
        include Collections

        def initialize(options = {})
          require 'hapi'
          @connection = HAPI.new( :authkey => { :key => options[:voxel_api_key], :secret => options[:voxel_api_secret] }, :default_format => :ruby ) 
        end

        def request(method_name, options = {})
          api_method_name = @connection.translate_api_to_method( method_name )
          @connection.send(api_method_name, options)
        end
      end
    end
  end
end
