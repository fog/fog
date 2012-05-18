module Fog
  module Compute
    class Ecloudv2
      class SshKey < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :default, :aliases => :Default, :type => :boolean
        attribute :finger_print, :aliases => :FingerPrint

        
        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
