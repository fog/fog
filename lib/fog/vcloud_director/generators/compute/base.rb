module Fog
  module Generators
    module Compute
      module VcloudDirector
        class Base

          attr_reader :options

          def initialize(options)
            @options = options
          end

          # @return [String]
          def to_xml
            builder.to_xml(:ident => 0)
          end

          # @return [String]
          def pretty_xml
            builder.to_xml
          end

          # @api private
          # @return [Nokogiri::XML::Document]
          def doc
            builder.doc
          end

          protected

          # @api private
          def builder
          end

        end
      end
    end
  end
end
