module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetOrganization < Fog::Parsers::Base

          def reset
            @response = { 'vdcs' => [] }
          end

          def start_element(name, attrs = [])
            case name
            when 'Org'
              @response['name'] = attr_value('name', attrs)
              @response['uri']  = attr_value('href', attrs)
            when 'Link'
              href = attr_value('href', attrs)

              case attr_value('type', attrs)
              when 'application/vnd.vmware.vcloud.vdc+xml'
                @response['vdcs'].push({ 'name' => attr_value('name', attrs), 'uri' => href })
              when 'application/vnd.vmware.vcloud.catalog+xml'
                @response['catalog_uri'] = href
              when 'application/vnd.vmware.vcloud.tasksList+xml'
                @response['tasksList_uri'] = href
              when 'application/vnd.tmrk.ecloud.keysList+xml'
                @response['keysList_uri'] = href
              when 'application/vnd.tmrk.ecloud.tagsList+xml'
                @response['tagsList_uri'] = href
              end
            end
          end

        end
      end
    end
  end
end
