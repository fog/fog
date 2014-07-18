module Fog
    module Compute
        class ProfitBricks
            class Image < Fog::Model
                identity  :id,             :aliases => 'imageId'
                attribute :name,           :aliases => 'imageName'
                attribute :type,           :aliases => 'imageType'
                attribute :size,           :aliases => 'imageSize'
                attribute :cpu_hotplug,    :aliases => 'cpuHotpluggable'
                attribute :memory_hotplug, :aliases => 'memoryHotpluggable'
                attribute :server_ids,     :aliases => 'serverIds'
                attribute :os_type,        :aliases => 'osType'
                attribute :writeable
                attribute :region
                attribute :public

                def initialize(attributes={})
                    super
                end
            end
        end
    end
end