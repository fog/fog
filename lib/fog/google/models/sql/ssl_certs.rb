require 'fog/core/collection'
require 'fog/google/models/sql/ssl_cert'

module Fog
  module Google
    class SQL
      class SslCerts < Fog::Collection
        model Fog::Google::SQL::SslCert

        ##
        # Lists all of the current SSL certificates for the instance
        #
        # @param [String] instance_id Instance ID
        # @return [Array<Fog::Google::SQL::SslCert>] List of SSL certificate resources
        def all(instance_id)
          data = []
          begin
            data = service.list_ssl_certs(instance_id).body['items'] || []
          rescue Fog::Errors::Error => e
            # Google SQL returns a 403 if we try to access a non-existing resource
            # The default behaviour in Fog is to return an empty Array
            raise e unless e.message == 'The client is not authorized to make this request.'
          end

          load(data)
        end

        ##
        # Retrieves a particular SSL certificate (does not include the private key)
        #
        # @param [String] instance_id Instance ID
        # @param [String] sha1_fingerprint Sha1 FingerPrint
        # @return [Fog::Google::SQL::SslCert] SSL certificate resource
        def get(instance_id, sha1_fingerprint)
          if ssl_cert = service.get_ssl_cert(instance_id, sha1_fingerprint).body
            new(ssl_cert)
          end
        rescue Fog::Errors::NotFound
          nil
        rescue Fog::Errors::Error => e
          # Google SQL returns a 403 if we try to access a non-existing resource
          # The default behaviour in Fog is to return a nil
          return nil if e.message == 'The client is not authorized to make this request.'
          raise e
        end
      end
    end
  end
end
