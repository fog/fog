module Fog
  module Parsers
    module Storage
      module InternetArchive
        class GetBucketLifecycle < Fog::Parsers::Base
          def reset
            @expiration = {}
            @transition = {}
            @rule = {}
            @response = { 'Rules' => [] }
          end

          def start_element(name, attrs=[])
            super
            case name
            when 'Expiration'
              @in_expiration = true
            when 'Transition'
              @in_transition = true
            end
          end

          def end_element(name)
            if @in_expiration
              case name
              when 'Days'
                @expiration[name] = value.to_i
              when 'Date'
                @expiration[name] = value
              when 'Expiration'
                @rule['Expiration'] = @expiration
                @in_expiration = false
                @expiration = {}
              end
            elsif @in_transition
              case name
              when 'StorageClass',
                @transition['StorageClass'] = value
              when 'Date'
                @transition[name] = value
              when 'Days'
                @transition[name] = value.to_i
              when 'Transition'
                @rule['Transition'] = @transition
                @in_transition = false
                @transition = {}
              end
            else
              case name
              when 'ID', 'Prefix'
                @rule[name] = value
              when 'Status'
                @rule['Enabled'] = value == 'Enabled'
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
end
