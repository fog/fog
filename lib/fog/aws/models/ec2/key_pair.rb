module Fog
  module AWS
    class EC2

      class KeyPair < Fog::Model

        attr_accessor :fingerprint, :material, :name

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'keyFingerprint'  => :fingerprint,
            'keyMaterial'     => :material,
            'keyName'         => :name
          })
          super
        end

        def delete
          return false if new_record?
          connection.delete_key_pair(@name)
          @new_record = true
          true
        end

        def save
          data = connection.create_key_pair(@name)
          new_attributes = data['Body'].reject {|key,value| !['keyFingerprint', 'keyMaterial', 'keyName'].include?(key)}
          update_attributes(new_attributes)
          @new_record = false
          true
        end

      end

    end
  end
end
