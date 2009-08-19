module Fog
  module AWS
    class EC2

      class KeyPair < Fog::Model

        attr_accessor :fingerprint,
                      :material,
                      :name

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'keyFingerprint'  => :fingerprint,
            'keyMaterial'     => :material,
            'keyName'         => :name
          })
          super
        end

        def delete
          connection.delete_key_pair(@name)
        end

        def save
          data = connection.create_key_pair(@name).body
          new_attributes = data.reject {|key,value| !['keyFingerprint', 'keyMaterial', 'keyName'].include?(key)}
          update_attributes(new_attributes)
          data
        end

      end

    end
  end
end
