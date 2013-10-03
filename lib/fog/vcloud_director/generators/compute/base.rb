module Fog
  module Generators
    module Compute
      module VcloudDirector
        class Base

          attr_reader :builder, :data, :root_attributes

          # @param [Hash] data
          def initialize(data={})
            @data = data
            @root_attributes = {}
          end

          # @return [String]
          def to_xml
            build
            builder.doc.root.to_xml(:ident => 0)
          end

          # @return [String]
          def pretty_xml
            build
            builder.doc.root.to_xml
          end

          # @api private
          # @return [Nokogiri::XML::Document]
          def doc
            build
            builder.doc
          end

          protected

          def build
            @root_attributes.delete_if {|k, v| v.nil?}
            @builder ||= Nokogiri::XML::Builder.new do |xml|
              xml.send(self.class.to_s.split('::').last, @root_attributes) do |x|
                inner_build(x)
              end
            end
          end

          def with(root)
            @root_attributes.delete_if {|k, v| v.nil?}
            @builder ||= Nokogiri::XML::Builder.with(root) do |xml|
              xml.send(self.class.to_s.split('::').last, @root_attributes) do |x|
                inner_build(x)
              end
            end
          end

        end
      end
    end
  end
end
