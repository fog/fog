module Fog
  module Compute
    class Ecloud
      class AdminOrganization < Fog::Ecloud::Model
        identity :href

        attribute :name,                :aliases => :Name
        attribute :type,                :aliases => :Type
        attribute :other_links,         :aliases => :Links, :squash => :Link
        attribute :multifactor_summary, :aliases => :MultifactorSummary
        attribute :support_access,      :aliases => :SupportAccess

        def ssh_keys
          @ssh_keys = Fog::Compute::Ecloud::SshKeys.new(:service => service, :href => "/cloudapi/ecloud/admin/sshKeys/organizations/#{organization.id}")
        end

        def password_complexity_rules
          @password_complexity_rules = Fog::Compute::Ecloud::PasswordComplexityRules.new(:service => service, :href => "/cloudapi/ecloud/admin/organizations/#{organization.id}/passwordComplexityRules")
        end

        def login_banner
          @login_banner = Fog::Compute::Ecloud::LoginBanner.new(:service => service, :href => "/cloudapi/ecloud/admin/organizations/#{organization.id}/loginBanner")
        end

        def authentication_levels
          @authentication_levels = Fog::Compute::Ecloud::AuthenticationLevels.new(:service => service, :href => "/cloudapi/ecloud/admin/organizations/#{organization.id}/authenticationLevels")
        end

        def id
          href.scan(/\d+/)[0]
        end

        def organization
          @organization ||= begin
                              reload unless other_links
                              organization_link = other_links.find{|l| l[:type] == "application/vnd.tmrk.cloud.organization"}
                              self.service.organizations.new(organization_link)
                            end
        end
      end
    end
  end
end
