module Fog
  module Compute
    class Ecloudv2
      class AdminOrganization < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :multifactor_summary, :aliases => :MultifactorSummary
        attribute :support_access, :aliases => :SupportAccess

        def ssh_keys
          @ssh_keys = Fog::Compute::Ecloudv2::SshKeys.new(:connection => connection, :href => "/cloudapi/ecloud/admin/sshKeys/organizations/#{org_id}")
        end

        def password_complexity_rules
          @password_complexity_rules = Fog::Compute::Ecloudv2::PasswordComplexityRules.new(:connection => connection, :href => "/cloudapi/ecloud/admin/organizations/#{org_id}/passwordComplexityRules")
        end

        def login_banner
          @login_banner = Fog::Compute::Ecloudv2::LoginBanner.new(:connection => connection, :href => "/cloudapi/ecloud/admin/organizations/#{org_id}/loginBanner")
        end

        def authentication_levels
          @authentication_levels = Fog::Compute::Ecloudv2::AuthenticationLevels.new(:connection => connection, :href => "/cloudapi/ecloud/admin/organizations/#{org_id}/authenticationLevels")
        end

        def id
          href.scan(/\d+/)[0]
        end

        def org_id
          other_links[:Link].detect { |l| l[:type] == "application/vnd.tmrk.cloud.organization" }[:href].scan(/\d+/)[0]
        end
      end
    end
  end
end
