module Fog
  module Compute
    class Ecloudv2
      class Row < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :index, :aliases => :Index

        def groups
          @groups = Fog::Compute::Ecloudv2::Groups.new(:connection => connection, :href => href)
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
