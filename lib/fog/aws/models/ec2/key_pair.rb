module Fog
  module AWS
    class EC2

      class KeyPair < Fog::Model

        identity  :name,        'keyName'

        attribute :fingerprint, 'keyFingerprint'
        attribute :material,    'keyMaterial'

        def destroy
          connection.delete_key_pair(@name)
          true
        end

        def save
          data = connection.create_key_pair(@name).body
          new_attributes = data.reject {|key,value| !['keyFingerprint', 'keyMaterial', 'keyName'].include?(key)}
          merge_attributes(new_attributes)
          true
        end

      end

    end
  end
end
