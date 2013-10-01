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
        #
        # ==== See Also
        # http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_TempURL-d1a444.html
        def get_object_https_url(container, object, expires, options = {})
          create_temp_url(container, object, expires, "GET", "https", options)
        end
        
        # Get an expiring object url from Cloud Files
        # The function uses the scheme used by the storage object (http or https)
        #
        # ==== Parameters
        # * container<~String> - Name of container containing object
        # * object<~String> - Name of object to get expiring url for
        # * expires_secs<~Time> - The duration in seconds of the validity for the generated url
        # * method<~String> - The name of the method to be accessible via the url ("GET", "PUT" or "HEAD")
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~String> - url for object
        #
        # ==== See Also
        # http://docs.rackspace.com/files/api/v1/cf-devguide/content/Create_TempURL-d1a444.html
        def generate_object_temp_url(container, object, expires_secs, method, options = {})
          expires = (Time.now + expires_secs.to_i).to_i
          create_temp_url(container, object, expires, method, @scheme, options)
        end

        private

        def sig_to_hex(str)
          str.unpack("C*").map { |c|
            c.to_s(16)
          }.map { |h|
            h.size == 1 ? "0#{h}" : h
          }.join
        end
        
        def create_temp_url(container, object, expires, method, scheme, options = {})
          raise ArgumentError, "Insufficient parameters specified." unless (container && object && expires && method)
          raise ArgumentError, "Storage must my instantiated with the :openstack_temp_url_key option" if @openstack_temp_url_key.nil?
          
          
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

      end

    end
  end
end
