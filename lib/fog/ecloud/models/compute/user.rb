module Fog
  module Compute
    class Ecloud
      class User < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :first_name, :aliases => :FirstName
        attribute :last_name, :aliases => :LastName
        attribute :email, :aliases => :Email
        attribute :status, :aliases => :Status
        attribute :last_login, :aliases => :LastLogin
        attribute :multifactor_authentication, :aliases => :MultifactorAuthentication
        attribute :is_administrator, :aliases => :IsAdministrator, :type => :boolean
        attribute :is_api_user, :aliases => :IsApiUser, :type => :boolean
        attribute :is_alert_notification_enabled, :aliases => :IsAlertNotificationEnabled, :type => :boolean
        attribute :is_multifactor_authentication_enabled, :aliases => :IsMultifactorAuthenticationEnabled, :type => :boolean

        def roles
          @roles = Fog::Compute::Ecloud::Roles.new(:service => service, :href => "#{service.base_path}/admin/roles/users/#{id}")
        end

        def api_keys
          @api_keys = Fog::Compute::Ecloud::ApiKeys.new(:service => service, :href => "#{service.base_path}/admin/apiKeys/users/#{id}")
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
