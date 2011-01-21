module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetVersions < Fog::Parsers::Base

          def reset
            @response = { 'SupportedVersions' => [] }
            @version_info = {}
          end

          def end_element(name)
            case name
            when 'LoginUrl', 'Version'
              @version_info[name] = @value
            when 'VersionInfo'
              @response['SupportedVersions'] << @version_info
              @version_info = {}
            end
          end

        end

      end
    end
  end
end
