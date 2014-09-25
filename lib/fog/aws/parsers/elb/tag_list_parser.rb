module Fog
  module Parsers
    module AWS
      module ELB
        # parses an XML-formatted list of resource tags from AWS
        class TagListParser < Fog::Parsers::Base

          # each tag is modeled as a String pair (2-element Array)
          def reset
            @this_key   = nil
            @this_value = nil
            @tags       = Hash.new
            @response   = {'DescribeTags' => {'TagList' => {}}}
          end

          def end_element(name)
            super
            case name
              when 'Tag'
                @tags[@this_key] = @this_value
                @this_key, @this_value = nil, nil
              when 'Key'
                @this_key = value
              when 'Value'
                @this_value = value
              when 'TagList'
                @response['DescribeTags']['TagList'] = @tags
            end
          end

        end
      end
    end
  end
end
