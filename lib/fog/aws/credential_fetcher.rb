require 'net/http'
require 'uri'
require 'fog/core/json'
module Fog
  module AWS
    module CredentialFetcher
      INSTANCE_METADATA_URI = "http://169.254.169.254/latest/meta-data/iam/security-credentials/"
      module ServiceMethods
        def fetch_credentials(options)
          if options[:use_iam_profile]
            begin
              role_name = Net::HTTP.get_response(URI.parse(INSTANCE_METADATA_URI))
              role_name.error! unless role_name.is_a?(Net::HTTPSuccess)
              role_data = Net::HTTP.get_response(URI.parse(INSTANCE_METADATA_URI+role_name.body))
              role_data.error! unless role_data.is_a?(Net::HTTPSuccess)

              session = Fog::JSON.decode(role_data.body)
              credentials = {}
              credentials[:aws_access_key_id] = session['AccessKeyId']  
              credentials[:aws_secret_access_key] = session['SecretAccessKey']
              credentials[:aws_session_token] = session['Token']
              credentials[:aws_credentials_expire_at] = Time.xmlschema session['Expiration']
              #these indicate the metadata service is unavailable or has no profile setup
              credentials
            rescue Errno::EHOSTUNREACH, Errno::ECONNREFUSED, SocketError, Timeout::Error, Net::HTTPError, Net::HTTPServerException => e
              Fog::Logger.warning("Unable to fetch credentuals: #{e.message}")
              super
            end
          else
            super
          end
        end
      end

      module ConnectionMethods
        
        def refresh_credentials_if_expired
          refresh_credentials if credentials_expired?
        end

        private

        def credentials_expired?
          @use_iam_profile && 
            (!@aws_credentials_expire_at || 
             (@aws_credentials_expire_at && Fog::Time.now > @aws_credentials_expire_at - 15)) #new credentials become available from around 5 minutes before expiration time
        end

        def refresh_credentials
          if @use_iam_profile
            new_credentials = service.fetch_credentials :use_iam_profile => @use_iam_profile
            if new_credentials.any?
              setup_credentials new_credentials
              return true
            else
              false
            end
          else
            false
          end
        end
      end
    end
  end
end

