require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class Account < Fog::Model

        identity :id
        attribute :resource_type
        attribute :url
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
        attribute :telephone_verified
        attribute :verified_telephone
        attribute :verified_at, :type => :time
        attribute :verified_ip
        attribute :valid_credit_card, :type => :boolean
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
        attribute :created_at, :type => :time

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