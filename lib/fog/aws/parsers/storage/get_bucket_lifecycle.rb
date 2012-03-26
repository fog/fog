module Fog
  module Parsers
    module Storage
      module AWS

        class GetBucketLifecycle < Fog::Parsers::Base

          def reset
            @rule = {}
            @response = { 'Rules' => [] }
          end

          def end_element(name)
            case name
            when 'ID', 'Prefix'
              @rule[name] = value
            when 'Status'
              @rule['Enabled'] = value == 'Enabled'
            when 'Days'
              @rule[name] = value.to_i
            when 'Rule'
              @response['Rules'] << @rule
              @rule = {}
            end
          end

        end

      end
    end
  end
end
