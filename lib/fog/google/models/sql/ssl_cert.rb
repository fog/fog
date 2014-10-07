require 'fog/core/model'

module Fog
  module Google
    class SQL
      ##
      # A SSL certificate resource
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/sslCerts
      class SslCert < Fog::Model
        identity :sha1_fingerprint, :aliases => 'sha1Fingerprint'

        attribute :cert
        attribute :cert_serial_number, :aliases => 'certSerialNumber'
        attribute :common_name, :aliases => 'commonName'
        attribute :create_time, :aliases => 'createTime'
        attribute :expiration_time, :aliases => 'expirationTime'
        attribute :instance
        attribute :kind

        # These attributes are not available in the representation of a 'SSL Certificate' returned by the SQL API.
        # These attributes are only available as a reponse to a create operation
        attribute :server_ca_cert, :aliases => 'serverCaCert'
        attribute :cert_private_key, :aliases => 'certPrivateKey'

        ##
        # Deletes a SSL certificate. The change will not take effect until the instance is restarted.
        #
        # @param [Hash] options Method options
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def destroy(options = {})
          requires :instance, :identity

          data = service.delete_ssl_cert(self.instance, self.identity)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          unless options.fetch(:async, true)
            operation.wait_for { ready? }
          end
          operation
        end

        ##
        # Reloads a SSL certificate
        #
        # @return [Fog::Google::SQL::SslCert] SSL certificate resource
        def reload
          requires :instance, :identity

          data = collection.get(self.instance, self.identity)
          merge_attributes(data.attributes)
          self
        end

        ##
        # Creates a SSL certificate. The new certificate will not be usable until the instance is restarted.
        #
        # @raise [Fog::Errors::Error] If SSL certificate already exists
        def save
          requires :instance, :common_name

          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?

          data = service.insert_ssl_cert(self.instance, self.common_name).body
          merge_attributes(data['clientCert']['certInfo'])
          self.server_ca_cert = Fog::Google::SQL::SslCert.new(data['serverCaCert'])
          self.cert_private_key = data['clientCert']['certPrivateKey']
          self
        end
      end
    end
  end
end
