require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class LoadBalancer < Fog::Model

        identity :id
        attribute :url
        attribute :resource_type

        attribute :name
        attribute :status

        attribute :policy
        attribute :nodes
        attribute :healthcheck
        attribute :listeners

        # These SSL attributes act only as setters. You can not read certs or keys via the API
        attribute :certificate_pem
        attribute :certificate_private_key

        # These SSL attributes act only as getters for metadata
        attribute :certificate_valid_from
        attribute :certificate_expires_at
        attribute :certificate_issuer
        attribute :certificate_subject

        # Times
        attribute :created_at, :type => :time
        attribute :deleted_at, :type => :time

        # Links - to be replaced
        attribute :account
        attribute :server
        attribute :cloud_ip

        def ready?
          status == 'active'
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :nodes, :listeners, :healthcheck
          options = {
            :nodes => nodes,
            :listeners => listeners,
            :healthcheck => healthcheck,
            :policy => policy,
            :name => name,
            :certificate_pem => certificate_pem,
            :certificate_private_key => certificate_private_key
          }.delete_if { |k, v| v.nil? || v == "" }
          data = service.create_load_balancer(options)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          service.destroy_load_balancer(identity)
          true
        end

        # SSL cert metadata for expiration of certificate
        def certificate_expires_at
          attributes[:certificate_expires_at]
        end

        # SSL cert metadata for subject
        def certificate_subject
          attributes[:certificate_subject]
        end

        # Sets the certificate metadata from the JSON object that contains it.
        #
        # It is used by fog's attribute setting and should not be used for attempting to set a
        # certificate on a load balancer.
        #
        # @private
        def certificate=(cert_metadata)
          if cert_metadata
            attributes[:certificate_valid_from] = time_or_original(cert_metadata["valid_from"])
            attributes[:certificate_expires_at] = time_or_original(cert_metadata["expires_at"])
            attributes[:certificate_issuer] = cert_metadata["issuer"]
            attributes[:certificate_subject] = cert_metadata["subject"]
          else
            attributes[:certificate_valid_from] = nil
            attributes[:certificate_expires_at] = nil
            attributes[:certificate_issuer] = nil
            attributes[:certificate_subject] = nil
          end
        end

        private

        def time_or_original(value)
          Time.parse(value)
        rescue TypeError, ArgumentError
          value
        end
      end
    end
  end
end
