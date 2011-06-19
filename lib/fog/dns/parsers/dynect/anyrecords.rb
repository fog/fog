module Fog
  module Parsers
    module Dynect
      module DNS

        class AnyRecords < Fog::Parsers::Base

          def reset
            @response = []
          end

          def end_element(name)
            case name
            when /.+RecordURI$/
              matches = @value.match(/\/REST\/(.+)Record\/(.+)\/(.+)\/(.+)/).to_a
              _, record_type, zone, fqdn, recordid = matches

              @response << ({"zone" => zone,
                              "fqdn" => fqdn,
                              "recordid" => recordid,
                              "record_type" => record_type})
            end
          end

        end
      end
    end
  end
end
