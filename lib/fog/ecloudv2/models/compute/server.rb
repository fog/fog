module Fog
  module Compute
    class Ecloudv2
      class Server < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type , :aliases => :Type
        attribute :status, :aliases => :Status
        attribute :storage, :aliases => :Storage
        attribute :operating_system, :aliases => :OperatingSystem
        attribute :powered_on, :aliases => :PoweredOn
        attribute :tools_status, :aliases => :ToolsStatus
        attribute :cpus, :aliases => :ProcessorCount
        attribute :memory, :aliases => :Memory

      end
    end
  end
end
