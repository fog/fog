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
      request :voxcloud_create
      request :voxcloud_status
			request :voxcloud_delete

      class Mock
        include Collections
      end

      class Real
        include Collections

        def initialize(options = {})
          require 'time'
          require 'digest/md5'

          @voxel_api_key = options[:voxel_api_key]
          @voxel_api_secret = options[:voxel_api_secret]

          Excon.ssl_verify_peer = false

          @connection = Fog::Connection.new("https://api.voxel.net:443")
        end

        def request(method_name, options = {})
          begin
            options.merge!( { :method => method_name, :timestamp => Time.now.xmlschema, :key => @voxel_api_key } )
            options[:api_sig] = create_signature(@voxel_api_secret, options)
            require 'xmlsimple'
            response = @connection.request( :host => "api.voxel.net", :path => "/version/1.0/", :query => options )
            XmlSimple.xml_in( response.body, 'ForceArray' => false )
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Voxel::Compute::NotFound.slurp(error)
            else
              error
            end
          end
        end

        def create_signature(secret, options)
          to_sign = options.keys.map { |k| k.to_s }.sort.map { |k| "#{k}#{options[k.to_sym]}" }.join("")
          Digest::MD5.hexdigest( secret + to_sign )
        end
      end
    end
  end
end
