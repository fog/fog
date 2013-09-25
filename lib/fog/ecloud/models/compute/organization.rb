module Fog
  module Compute
    class Ecloud
      class Organization < Fog::Ecloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links, :squash => :Link

        def locations
          @locations ||= Fog::Compute::Ecloud::Locations.new( :service => service, :href => href )
        end

        def environments
          @environments ||= self.service.environments(:href => href)
        end

        def tags
          @tags ||= self.service.tags(:href => "/cloudapi/ecloud/deviceTags/organizations/#{id}")
        end

        def admin
          @admin ||= self.service.admin_organizations.new(:href => "/cloudapi/ecloud/admin/organizations/#{id}")
        end

        def users
          @users ||= self.service.users(:href => "/cloudapi/ecloud/admin/users/organizations/#{id}")
        end

        def support_tickets(type = :open)
          case type
          when :open
            @support_tickets ||= Fog::Compute::Ecloud::SupportTickets.new(:service => service, :href => "/cloudapi/ecloud/admin/tickets/organizations/#{id}/active")
          when :closed
            @support_tickets ||= Fog::Compute::Ecloud::SupportTickets.new(:service => service, :href => "/cloudapi/ecloud/admin/tickets/organizations/#{id}/closed")
          end
        end

        def edit_authentication_levels(options = {})
          options[:uri] = "/cloudapi/ecloud/admin/organizations/#{id}/authenticationLevels"
          data = service.admin_edit_authentication_levels(options).body
          level = Fog::Compute::Ecloud::AdminOrganizations.new(:service => service, :href => data[:href])[0]
        end

        def edit_password_complexity_rules(options = {})
          options[:uri] = "/cloudapi/ecloud/admin/organizations/#{id}/passwordComplexityRules"
          data = service.admin_edit_password_complexity_rules(options).body
          level = Fog::Compute::Ecloud::PasswordComplexityRules.new(:service => service, :href => data[:href])[0]
        end

        def edit_login_banner(options = {})
          options[:uri] = "/cloudapi/ecloud/admin/organizations/#{id}/loginBanner"
          data = service.admin_edit_login_banner(options).body
          banner = Fog::Compute::Ecloud::LoginBanners.new(:service => service, :href => data[:href])[0]
        end

        def enable_support_access(options = {})
          options[:uri] = "/cloudapi/ecloud/admin/organizations/#{id}/action/enableSupportAccess"
          service.admin_enable_support_access(options[:uri])
        end

        def disable_support_access(options = {})
          options[:uri] = "/cloudapi/ecloud/admin/organizations/#{id}/action/disableSupportAccess"
          service.admin_disable_support_access(options[:uri])
        end

        def id
          href.scan(/\d+/)[0]
        end

        alias :vdcs :environments
      end
    end
  end
end
