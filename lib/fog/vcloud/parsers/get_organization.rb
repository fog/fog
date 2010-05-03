module Fog
  module Parsers
    module Vcloud

      class GetOrganization < Fog::Parsers::Vcloud::Base
        #
        # Based off of:
        # http://support.theenterprisecloud.com/kb/default.asp?id=540&Lang=1&SID=
        # 
        # vCloud API Guide v0.9 - Page 26
        #

        def reset
          @response = Struct::VcloudOrganization.new([])
        end

        def start_element(name, attributes)
          @value = ''
          case name
          when 'Link'
            @response.links << generate_link(attributes)
          when 'Org'
            handle_root(attributes)
          end
        end

        def end_element(name)
          if name == 'Description'
            @response.description = @value
          end
        end

      end

    end
  end
end
