require 'fog/core'

module Fog
  module RiakCS

    module MultipartUtils
      require 'net/http'

      class Headers
        include Net::HTTPHeader

        def initialize
          initialize_http_header({})
        end

        # Parse a single header line into its key and value
        # @param [String] chunk a single header line
        def self.parse(chunk)
          line = chunk.strip
          # thanks Net::HTTPResponse
          return [nil,nil] if chunk =~ /\AHTTP(?:\/(\d+\.\d+))?\s+(\d\d\d)\s*(.*)\z/in
          m = /\A([^:]+):\s*/.match(line)
          [m[1], m.post_match] rescue [nil, nil]
        end

        # Parses a header line and adds it to the header collection
        # @param [String] chunk a single header line
        def parse(chunk)
          key, value = self.class.parse(chunk)
          add_field(key, value) if key && value
        end
      end

      def parse(data, boundary)
        contents = data.match(end_boundary_regex(boundary)).pre_match rescue ""
        contents.split(inner_boundary_regex(boundary)).reject(&:empty?).map do |part|
          parse_multipart_section(part)
        end.compact
      end

      def extract_boundary(header_string)
        $1 if header_string =~ /boundary=([A-Za-z0-9\'()+_,-.\/:=?]+)/
      end

      private
      def end_boundary_regex(boundary)
        /\r?\n--#{Regexp.escape(boundary)}--\r?\n?/
      end

      def inner_boundary_regex(boundary)
        /\r?\n--#{Regexp.escape(boundary)}\r?\n/
      end

      def parse_multipart_section(part)
        headers = Headers.new
        if md = part.match(/\r?\n\r?\n/)
          body = md.post_match
          md.pre_match.split(/\r?\n/).each do |line|
            headers.parse(line)
          end

          if headers["content-type"] =~ /multipart\/mixed/
            boundary = extract_boundary(headers.to_hash["content-type"].first)
            parse(body, boundary)
          else
            {:headers => headers.to_hash, :body => body}
          end
        end
      end
    end

    module UserUtils
      def update_riakcs_user(key_id, user)
        response = @s3_connection.put_object('riak-cs', "user/#{key_id}", Fog::JSON.encode(user), { 'Content-Type' => 'application/json' })
        if !response.body.empty?
          response.body = Fog::JSON.decode(response.body)
        end
        response
      end

      def update_mock_user(key_id, user)
        if data[key_id]
          if status = user[:status]
            data[key_id][:status] = status
          end

          if user[:new_key_secret]
            data[key_id][:key_secret] = rand(100).to_s
          end

          Excon::Response.new.tap do |response|
            response.status = 200
            response.body   = data[key_id]
          end
        else
          Excon::Response.new.tap do |response|
            response.status = 403
          end
        end
      end
    end

    module Utils
      def configure_uri_options(options = {})
        @host       = options[:host]       || 'localhost'
        @persistent = options[:persistent] || true
        @port       = options[:port]       || 8080
        @scheme     = options[:scheme]     || 'http'
      end

      def riakcs_uri
        "#{@scheme}://#{@host}:#{@port}"
      end
    end

    extend Fog::Provider

    service(:provisioning, 'Provisioning')
    service(:usage,        'Usage')

  end
end
