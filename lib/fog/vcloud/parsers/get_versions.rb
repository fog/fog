module Fog
  module Parsers
    module Vcloud

      class GetVersions < Fog::Parsers::Base
        #
        # Based off of:
        # http://support.theenterprisecloud.com/kb/default.asp?id=535&Lang=1&SID=
        # https://community.vcloudexpress.terremark.com/en-us/product_docs/w/wiki/02-get-versions.aspx
        # vCloud API Guide v0.9 - Page 89
        #

        def reset
          @response = []
          @supported = false
        end

        def start_element(name, attributes = {})
          @value = ''
          case name
          when "Version"
            @version = Struct::VcloudVersion.new
          when "SupportedVersions"
            @supported = true
          end
        end

        def end_element(name)
          case name
          when "Version"
            @version.version = @value
            @version.supported = @supported
          when "LoginUrl"
            @version.login_url = @value
          when "VersionInfo"
            @response << @version
          when "SupportedVersions"
            @supported = false
          end
        end

      end

    end
  end
end
