module Fog
  module Parsers
    module Vcloud
      class Base < Fog::Parsers::Base

        private

        def generate_link(attributes)
          link = Struct::VcloudLink.new
          until attributes.empty?
            link[attributes.shift.downcase] = attributes.shift
          end
          link
        end

        def handle_root(attributes)
          root = {}
          until attributes.empty?
            if attributes.first.is_a?(Array)
              attribute = attributes.shift
              root[attribute.first.downcase] = attribute.last
            else
              root[attributes.shift.downcase] = attributes.shift
            end
          end
          @response.href = root['href']
          @response.name = root['name']
          @response.type = root['type']
          @response.xmlns = root['xmlns']
        end
      end
    end
  end
end
