class VcloudDirector
  module Generators
    module Helpers

      def self.have_xsd?
        if @have_xsd.nil?
          unless @have_xsd = File.exist?(master)
            Fog::Logger.warning('XML schema not present, skipping validation')
          end
        end
        @have_xsd
      end

      def self.validate(doc)
        xsd.validate(doc).map(&:message)
      end

      private

      def self.master
        @master ||= File.expand_path('../../../fixtures/vcloud/v1.5/schema/master.xsd', __FILE__)
      end

      def self.xsd
        if @xsd.nil?
          Dir.chdir(File.dirname(master)) do
            @xsd = Nokogiri::XML::Schema.new(File.read(File.basename(master)))
          end
        end
        @xsd
      end

    end
  end
end
