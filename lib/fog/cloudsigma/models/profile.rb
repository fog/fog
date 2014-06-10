require 'fog/cloudsigma/nested_model'

module Fog
  module Compute
    class CloudSigma
      class Profile < Fog::CloudSigma::CloudsigmaModel
        identity :uuid

        attribute :last_name, :type => :string
        attribute :login_sms, :type => :boolean
        attribute :currency, :type => :string
        attribute :meta
        attribute :api_https_only, :type => :boolean
        attribute :first_name, :type => :string
        attribute :uuid, :type => :string
        attribute :title, :type => :string
        attribute :state, :type => :string
        attribute :email, :type => :string
        attribute :vat, :type => :string
        attribute :autotopup_amount, :type => :float
        attribute :reseller, :type => :string
        attribute :company, :type => :string
        attribute :key_auth, :type => :boolean
        attribute :phone, :type => :string
        attribute :address, :type => :string
        attribute :mailing_list, :type => :boolean
        attribute :town, :type => :string
        attribute :has_autotopup, :type => :boolean
        attribute :my_notes, :type => :string
        attribute :bank_reference, :type => :string
        attribute :language, :type => :string
        attribute :country, :type => :string
        attribute :postcode, :type => :string

        def save
          update
        end

        def update
          response = service.update_profile(attributes)
          self.attribute.merge!(response.body)

          self
        end
      end
    end
  end
end
