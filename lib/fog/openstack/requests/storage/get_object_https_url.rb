module Fog
  module Storage
    class OpenStack

      class Real

        # Get an expiring object https url from Cloud Files
        #
        # ==== Parameters
        # * container<~String> - Name of container containing object
        # * object<~String> - Name of object to get expiring url for
        # * expires<~Time> - An expiry time for this url
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        def get_object_https_url(container, object, expires, options = {})
          create_temp_url(container, object, expires, "GET", options.merge(:scheme => "https"))
        end
        
        # Get an expiring object http url
        #
        # ==== Parameters
        # * container<~String> - Name of container containing object
        # * object<~String> - Name of object to get expiring url for
        # * expires<~Time> - An expiry time for this url
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        def get_object_http_url(container, object, expires, options = {})
          create_temp_url(container, object, expires, "GET", options.merge(:scheme => "http"))
        end
        
        # creates a temporary url 
        #
        # ==== Parameters
        # * container<~String> - Name of container containing object
        # * object<~String> - Name of object to get expiring url for
        # * expires<~Time> - An expiry time for this url
        # * method<~String> - The method to use for accessing the object (GET, PUT, HEAD)
        # * scheme<~String> - The scheme to use (http, https)
        # * options<~Hash> - An optional options hash
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        #
        # ==== See Also
        # http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_TempURL-d1a444.html
        def create_temp_url(container, object, expires, method, options = {})
          raise ArgumentError, "Insufficient parameters specified." unless (container && object && expires && method)
          raise ArgumentError, "Storage must my instantiated with the :openstack_temp_url_key option" if @openstack_temp_url_key.nil?
          
          scheme = options[:scheme] || @scheme
          
          # POST not allowed
          allowed_methods = %w{GET PUT HEAD}
          unless allowed_methods.include?(method)
            raise ArgumentError.new("Invalid method '#{method}' specified. Valid methods are: #{allowed_methods.join(', ')}")
          end
          

          expires        = expires.to_i
          object_path_escaped   = "#{@path}/#{Fog::OpenStack.escape(container)}/#{Fog::OpenStack.escape(object,"/")}"
          object_path_unescaped = "#{@path}/#{Fog::OpenStack.escape(container)}/#{object}"
          string_to_sign = "#{method}\n#{expires}\n#{object_path_unescaped}"

          hmac = Fog::HMAC.new('sha1', @openstack_temp_url_key)
          sig  = sig_to_hex(hmac.sign(string_to_sign))

          "#{scheme}://#{@host}#{object_path_escaped}?temp_url_sig=#{sig}&temp_url_expires=#{expires}"
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

    end
  end
end
