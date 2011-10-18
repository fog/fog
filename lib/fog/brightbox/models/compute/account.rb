require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class Account < Fog::Model

        identity :id
        attribute :url
        attribute :resource_type

        attribute :name
        attribute :status

        attribute :address_1
        attribute :address_2
        attribute :city
        attribute :county
        attribute :postcode
        attribute :country_code
        attribute :country_name
        attribute :vat_registration_number
        attribute :telephone_number
        attribute :verified_telephone
        attribute :verified_ip
        attribute :ram_limit
        attribute :ram_used
        attribute :cloud_ips_limit
        attribute :cloud_ips_used
        attribute :load_balancers_limit
        attribute :load_balancers_used
        attribute :library_ftp_host
        attribute :library_ftp_user
        # This is always returned as null/nil unless performing a reset_ftp_password request
        attribute :library_ftp_password

        # Boolean flags
        attribute :valid_credit_card
        attribute :telephone_verified

        # Times
        attribute :created_at, :type => :time
        attribute :verified_at, :type => :time

        # Links - to be replaced
        attribute :owner_id, :aliases => "owner", :squash => "id"
        attribute :clients
        attribute :images
        attribute :servers
        attribute :users
        attribute :zones

        def reset_ftp_password
          requires :identity
          connection.reset_ftp_password_account(identity)["library_ftp_password"]
        end

      end

    end
  end
end