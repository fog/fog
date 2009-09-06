module Fog
  module AWS
    class EC2

      class KeyPair < Fog::Model

        attribute :fingerprint, 'keyFingerprint'
        attribute :material,    'keyMaterial'
        attribute :name,        'keyName'

        def initialize(attributes = {})
          super
        end

        def delete
          connection.delete_key_pair(@name)
          true
        end

        def save
          data = connection.create_key_pair(@name).body
          new_attributes = data.reject {|key,value| !['keyFingerprint', 'keyMaterial', 'keyName'].include?(key)}
          update_attributes(new_attributes)
          true
        end

      end

    end
  end
end
