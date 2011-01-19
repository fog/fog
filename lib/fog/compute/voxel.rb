module Fog
  module Voxel
    class Compute < Fog::Service

      requires :voxel_api_key, :voxel_api_secret

      model_path 'fog/compute/models/voxel'
      model       :image
      collection  :images

      request_path 'fog/compute/requests/voxel'
      request :images_list

      class Mock
        include Collections
      end

      class Real
        include Collections

        def initialize(options = {})
          require 'hapi'
          @connection = HAPI.new( :authkey => { :key => options[:voxel_api_key], :secret => options[:voxel_api_secret] }, :default_format => :ruby ) 
        end

        def request(voxel_method_name, options = {})
          STDERR.puts "Got called"
          @connection.send(voxel_method_name, options)
        end
      end
    end
  end
end
