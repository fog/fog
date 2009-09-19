module Fog
  module AWS
    class EC2

      class KeyPair < Fog::Model

        attribute :fingerprint, 'keyFingerprint'
        attribute :material,    'keyMaterial'
        attribute :name,        'keyName'

        def delete
          connection.delete_key_pair(@name)
          true
        end

        def key_pairs
          @key_pairs
        end

        def save
          data = connection.create_key_pair(@name).body
          new_attributes = data.reject {|key,value| !['keyFingerprint', 'keyMaterial', 'keyName'].include?(key)}
          update_attributes(new_attributes)
          true
        end

        private

        def key_pairs=(new_key_pairs)
          @key_pairs = new_key_pairs
        end

      end

    end
  end
end
