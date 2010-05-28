module Fog
  module Parsers
    module Vcloud

      def self.de_camel(str)
        str.gsub(/(.)([A-Z])/,'\1_\2').downcase
      end

      class Base < Fog::Parsers::Base

        private

        def generate_link(attributes)
          link = Struct::VcloudLink.new
          until attributes.empty?
            link[attributes.shift.downcase] = attributes.shift
          end
          if link.href
            link.href = URI.parse(link.href)
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
          @response.href = URI.parse(root['href'])
          @response.name = root['name']
          @response.type = root['type']
          @response.xmlns = root['xmlns']
        end
      end
    end
  end
end
