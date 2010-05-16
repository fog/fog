module Fog
  module Parsers
    module Vcloud

      class Login < Fog::Parsers::Vcloud::Base
        #
        # Based off of:
        # http://support.theenterprisecloud.com/kb/default.asp?id=536&Lang=1&SID=
        # https://community.vcloudexpress.terremark.com/en-us/product_docs/w/wiki/01-get-login-token.aspx
        # vCloud API Guide v0.9 - Page 17
        #

        def reset
          @response = Struct::VcloudOrgList.new([])
        end

        def start_element(name, attributes)
          @value = ''
          case name
          when 'OrgList'
            until attributes.empty?
              if at = attributes.shift
                if at[0] == "xmlns"
                  @response.xmlns = at[1]
                end
              end
            end
          when 'Org'
            @response.organizations << generate_link(attributes)
          end
        end

      end
    end
  end
end
