module Fog
  module Voxel
    class Compute < Fog::Service

      requires :voxel_api_key, :voxel_api_secret
      recognizes :provider, :host, :port, :scheme, :persistent

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

        def self.data
          @data ||= {
              :last_modified => { :servers => {}, :statuses => {}, :images => {} },
              :servers => [],
              :statuses => {},
              :images  => [
                { :id => 1, :name => "CentOS 5 x64" }, 
                { :id => 2, :name => "Ubuntu 10.04 LTS x64" } ]
            }
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end
       
        def initialize(options={})
          @data = self.class.data
        end
      end

      class Real
        include Collections

        def initialize(options = {})
          require 'time'
          require 'digest/md5'

          require 'fog/compute/parsers/voxel/images_list'
          require 'fog/compute/parsers/voxel/devices_list'

          @voxel_api_key = options[:voxel_api_key]
          @voxel_api_secret = options[:voxel_api_secret]

          @host   = options[:host]    || "api.voxel.net"
          @port   = options[:port]    || 443
          @scheme = options[:scheme]  || 'https'
          
          Excon.ssl_verify_peer = false

          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", :path => "/version/1.0/", :method => "POST" )
        end

        def request(method_name, options = {}, parser = nil)
          begin
            options.merge!( { :method => method_name, :timestamp => Time.now.xmlschema, :key => @voxel_api_key } )
            options[:api_sig] = create_signature(@voxel_api_secret, options)
            require 'xmlsimple'

            if parser.nil?
              response = @connection.request( :query => options )
              XmlSimple.xml_in( response.body, 'ForceArray' => false )
            else
              @connection.request( :query => options, :parser => parser )
            end
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
