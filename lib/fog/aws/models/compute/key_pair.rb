require 'fog/model'

module Fog
  module AWS
    class Compute

      class KeyPair < Fog::Model

        identity  :name,        :aliases => 'keyName'

        attribute :fingerprint, :aliases => 'keyFingerprint'
        attribute :material,    :aliases => 'keyMaterial'

        def destroy
          requires :name

          connection.delete_key_pair(@name)
          true
        end

        def save
          requires :name

          data = connection.create_key_pair(@name).body
          new_attributes = data.reject {|key,value| !['keyFingerprint', 'keyMaterial', 'keyName'].include?(key)}
          merge_attributes(new_attributes)
          true
        end

      end

    end
  end
end
