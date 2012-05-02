module Fog
  module Compute
    class Ecloudv2
      class Group < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :index, :aliases => :Index

        def servers
          @servers = Fog::Compute::Ecloudv2::Servers.new(:connection => connection, :href => href)
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
