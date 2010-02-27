module Fog
  module Rackspace
    class Files

      def self.dependencies
        [
          "fog/rackspace/models/files/directory.rb",
          "fog/rackspace/models/files/directories.rb",
          "fog/rackspace/models/files/file.rb",
          "fog/rackspace/models/files/files.rb",
          "fog/rackspace/requests/files/delete_container.rb",
          "fog/rackspace/requests/files/delete_object.rb",
          "fog/rackspace/requests/files/get_container.rb",
          "fog/rackspace/requests/files/get_containers.rb",
          "fog/rackspace/requests/files/get_object.rb",
          "fog/rackspace/requests/files/head_container.rb",
          "fog/rackspace/requests/files/head_containers.rb",
          "fog/rackspace/requests/files/head_object.rb",
          "fog/rackspace/requests/files/put_container.rb",
          "fog/rackspace/requests/files/put_object.rb"
        ]
      end

      def self.reload
        self.dependencies.each {|dependency| load(dependency)}
      end

      def initialize(options={})
        credentials = Fog::Rackspace.authenticate(options)
        @auth_token = credentials['X-Auth-Token']
        cdn_uri = URI.parse(credentials['X-CDN-Management-Url'])
        @cdn_host   = cdn_uri.host
        @cdn_path   = cdn_uri.path
        @cdn_port   = cdn_uri.port
        @cdn_scheme = cdn_uri.scheme
        storage_uri = URI.parse(credentials['X-Storage-Url'])
        @storage_host   = storage_uri.host
        @storage_path   = storage_uri.path
        @storage_port   = storage_uri.port
        @storage_scheme = storage_uri.scheme
      end

      def parse_data(data)
        metadata = {
          :body => nil,
          :headers => {}
        }
      
        if data.is_a?(String)
          metadata[:body] = data
          metadata[:headers]['Content-Length'] = metadata[:body].size.to_s
        else
          filename = ::File.basename(data.path)
          unless (mime_types = MIME::Types.of(filename)).empty?
            metadata[:headers]['Content-Type'] = mime_types.first.content_type
          end
          metadata[:body] = data.read
          metadata[:headers]['Content-Length'] = ::File.size(data.path).to_s
        end
        # metadata[:headers]['Content-MD5'] = Base64.encode64(Digest::MD5.digest(metadata[:body])).strip
        metadata
      end

      def cdn_request(params)
        @cdn_connection = Fog::Connection.new("#{@cdn_scheme}://#{@cdn_host}:#{@cdn_port}")
        response = @cdn_connection.request({
          :body     => params[:body],
          :expects  => params[:expects],
          :headers  => {
            'Content-Type' => 'application/json',
            'X-Auth-Token' => @auth_token
          }.merge!(params[:headers] || {}),
          :host     => @cdn_host,
          :method   => params[:method],
          :path     => "#{@cdn_path}/#{params[:path]}",
          :query    => params[:query]
        })
        unless response.body.empty?
          response.body = JSON.parse(response.body)
        end
        response
      end

      def storage_request(params, parse_json = true)
        @storage_connection = Fog::Connection.new("#{@storage_scheme}://#{@storage_host}:#{@storage_port}")
        response = @storage_connection.request({
          :body     => params[:body],
          :expects  => params[:expects],
          :headers  => {
            'Content-Type' => 'application/json',
            'X-Auth-Token' => @auth_token
          }.merge!(params[:headers] || {}),
          :host     => @storage_host,
          :method   => params[:method],
          :path     => "#{@storage_path}/#{params[:path]}",
          :query    => params[:query]
        })
        if !response.body.empty? && parse_json
          response.body = JSON.parse(response.body)
        end
        response
      end

    end
  end
end

Fog::Rackspace::Files.dependencies.each {|dependency| require(dependency)}
