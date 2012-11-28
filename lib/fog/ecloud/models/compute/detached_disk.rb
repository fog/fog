module Fog
  module Compute
    class Ecloud
      class DetachedDisk < Fog::Ecloud::Model
        identity :href

        attribute :name,        :aliases => :Name
        attribute :type,        :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :status,      :aliases => :Status
        attribute :size,        :aliases => :Size

        def ready?
          unless status =~ /AttachInProgress|DetachInProgress/
            true
          else
            false
          end
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
