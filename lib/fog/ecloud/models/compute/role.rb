module Fog
  module Compute
    class Ecloud
      class Role < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :environment_name, :aliases => :EnvironmentName
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :role_type, :aliases => :RoleType
        attribute :active, :aliases => :Active, :type => :boolean
        attribute :category, :aliases => :Category
        attribute :is_admin, :aliases => :IsAdmin, :type => :boolean
        attribute :business_operations, :aliases => :BusinessOperations

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
