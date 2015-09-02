module Fog
  module Storage
    class Rackspace
      module Common
        # Get an expiring object https url from Cloud Files
        #
        # ==== Parameters
        # * container<~String> - Name of container containing object
        # * object<~String> - Name of object to get expiring url for
        # * expires<~Time> - An expiry time for this url
        # * options<~Hash> - Options to override the method or scheme
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        # ==== See Also
        # http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_TempURL-d1a444.html
        def get_object_https_url(container, object, expires, options = {})
          if @rackspace_temp_url_key.nil?
            raise ArgumentError, "Storage must be instantiated with the :rackspace_temp_url_key option"
          end

          method         = options[:method] || 'GET'
          expires        = expires.to_i
          object_path_escaped   = "#{@uri.path}/#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object,"/")}"
          object_path_unescaped = "#{@uri.path}/#{Fog::Rackspace.escape(container)}/#{object}"
          string_to_sign = "#{method}\n#{expires}\n#{object_path_unescaped}"

          hmac = Fog::HMAC.new('sha1', @rackspace_temp_url_key)
          sig  = sig_to_hex(hmac.sign(string_to_sign))

          temp_url_query = {
              :temp_url_sig => sig,
              :temp_url_expires => expires
          }
          temp_url_query.merge!(:inline => true) if options[:inline]
          temp_url_query.merge!(:filename => options[:filename]) if options[:filename]
          temp_url_options = {
              :scheme => options[:scheme] || @uri.scheme,
              :host => @uri.host,
              :path => object_path_escaped,
              :query => temp_url_query.map { |param, val| "#{CGI.escape(param.to_s)}=#{CGI.escape(val.to_s)}" }.join('&')
          }
          URI::Generic.build(temp_url_options).to_s
        end

        private

        def sig_to_hex(str)
          str.unpack("C*").map { |c|
            c.to_s(16)
          }.map { |h|
            h.size == 1 ? "0#{h}" : h
          }.join
        end
      end

      class Mock
        include Common
      end

      class Real
        include Common
      end
    end
  end
end
