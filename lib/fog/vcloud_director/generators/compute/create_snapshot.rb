module Fog
  module Generators
    module Compute
      module VcloudDirector
        # @see http://pubs.vmware.com/vcd-56/topic/com.vmware.ICbase/PDF/vcd_56_api_guide.pdf @page 121
        class CreateSnapshot
          attr_reader :attrs

          def initialize(attrs={})
            @attrs = attrs
          end

          def generate_xml
            attrs = @attrs
            Nokogiri::XML::Builder.new do
              CreateSnapshotParams('xmlns' => 'http://www.vmware.com/vcloud/v1.5', 'memory' => attrs[:memory], 'name' => attrs[:name], 'quiesce' => attrs[:quiesce]) {
                Description attrs[:Description] if attrs.key?(:Description)
              }
            end.to_xml
          end
        end
      end
    end
  end
end
