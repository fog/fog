module Fog
  module Compute
    class Ecloudv2
      class Organization < Fog::Ecloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links

        def locations
          @locations ||= Fog::Compute::Ecloudv2::Locations.new( :connection => connection, :href => href )
        end

        def environments 
          @environments ||= Fog::Compute::Ecloudv2::Environments.new(:connection => connection, :href => href)
        end

        def tags
          @tags ||= Fog::Compute::Ecloudv2::Tags.new(:connection => connection, :href => "/cloudapi/ecloud/deviceTags/organizations/#{id}")
        end

        def admin
          @admin ||= Fog::Compute::Ecloudv2::AdminOrganizations.new(:connection => connection, :href => "/cloudapi/ecloud/admin/organizations/#{id}").first
        end

        def users
          @users ||= Fog::Compute::Ecloudv2::Users.new(:connection => connection, :href => "/cloudapi/ecloud/admin/users/organizations/#{id}")
        end

        def support_tickets(type = :open)
          case type
          when :open
            @support_tickets ||= Fog::Compute::Ecloudv2::SupportTickets.new(:connection => connection, :href => "/cloudapi/ecloud/admin/tickets/organizations/#{id}/active")
          when :closed
            @support_tickets ||= Fog::Compute::Ecloudv2::SupportTickets.new(:connection => connection, :href => "/cloudapi/ecloud/admin/tickets/organizations/#{id}/closed")
          end
        end

        def edit_authentication_levels(options = {})
          options[:uri] = "/cloudapi/ecloud/admin/organizations/#{id}/authenticationLevels"
          data = connection.admin_edit_authentication_levels(options).body
          level = Fog::Compute::Ecloudv2::AdminOrganizations.new(:connection => connection, :href => data[:href])[0]
        end

        def edit_password_complexity_rules(options = {})
          options[:uri] = "/cloudapi/ecloud/admin/organizations/#{id}/passwordComplexityRules"
          data = connection.admin_edit_password_complexity_rules(options).body
          level = Fog::Compute::Ecloudv2::PasswordComplexityRules.new(:connection => connection, :href => data[:href])[0]
        end

        def edit_login_banner(options = {})
          options[:uri] = "/cloudapi/ecloud/admin/organizations/#{id}/loginBanner"
          data = connection.admin_edit_login_banner(options).body
          banner = Fog::Compute::Ecloudv2::LoginBanners.new(:connection => connection, :href => data[:href])[0]
        end

        def enable_support_access(options = {})
          options[:uri] = "/cloudapi/ecloud/admin/organizations/#{id}/action/enableSupportAccess"
          connection.admin_enable_support_access(options[:uri])
        end

        def disable_support_access(options = {})
          options[:uri] = "/cloudapi/ecloud/admin/organizations/#{id}/action/disableSupportAccess"
          connection.admin_disable_support_access(options[:uri])
        end

        def id
          href.scan(/\d+/)[0]
        end

        alias :vdcs :environments
      end
    end
  end
end
