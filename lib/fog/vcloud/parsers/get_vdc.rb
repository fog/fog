module Fog
  module Parsers
    module Vcloud

      class GetVdc < Fog::Parsers::Vcloud::Base
        #WARNING: Incomplete
        #Based off of:
        #vCloud API Guide v0.9 - Page 27

        def reset
          @response = Struct::VcloudVdc.new([])
        end

        def start_element(name, attributes)
          @value = ''
          case name
          when 'Link'
            @response.links << generate_link(attributes)
          when 'Vdc'
            handle_root(attributes)
          end
        end

        def end_element(name)
          case name
          when "AllocationModel"
            @response.allocation_model = @value
          when "Description"
            @response.description = @value
          end
        end

      end

    end
  end
end
