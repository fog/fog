require "fog/json"

module Fog
  module AWS
    module CredentialFetcher
      INSTANCE_METADATA_HOST = "http://169.254.169.254"
      INSTANCE_METADATA_PATH = "/latest/meta-data/iam/security-credentials/"
      module ServiceMethods
        def fetch_credentials(options)
          if options[:use_iam_profile]
            begin
              connection = options[:connection] || Excon.new(INSTANCE_METADATA_HOST)
              role_name = connection.get(:path => INSTANCE_METADATA_PATH, :expects => 200).body
              role_data = connection.get(:path => INSTANCE_METADATA_PATH+role_name, :expects => 200).body

              session = Fog::JSON.decode(role_data)
              credentials = {}
              credentials[:aws_access_key_id] = session['AccessKeyId']
              credentials[:aws_secret_access_key] = session['SecretAccessKey']
              credentials[:aws_session_token] = session['Token']
              credentials[:aws_credentials_expire_at] = Time.xmlschema session['Expiration']
              #these indicate the metadata service is unavailable or has no profile setup
              credentials
            rescue Excon::Errors::Error => e
              Fog::Logger.warning("Unable to fetch credentials: #{e.message}")
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
