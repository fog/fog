module Fog
  module Compute
    class Ecloudv2
      class User < Fog::Ecloudv2::Model
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
          @roles = Fog::Compute::Ecloudv2::Roles.new(:connection => connection, :href => "/cloudapi/ecloud/admin/roles/users/#{id}")
        end

        def api_keys
          @api_keys = Fog::Compute::Ecloudv2::ApiKeys.new(:connection => connection, :href => "/cloudapi/ecloud/admin/apiKeys/users/#{id}")
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
