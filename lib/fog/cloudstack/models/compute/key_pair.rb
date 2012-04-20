require 'fog/core/model'

module Fog
  module Compute
    class Cloudstack

      class KeyPair < Fog::Model

        identity :name,         :aliases => 'keyName'

        attribute :fingerprint, :aliases => 'KeyFingerprint'
        attribute :private_key, :aliases => 'keyPriviateKey'

        attr_accessor :public_key

        def save
          requires :name
          requires :public_key

          params = {
            'name' => name,
            'publickey' => public_key
          }

          data = connection.register_ssh_key_pair(params).body

          self.private_key = data['privatekey']
          self.fingerprint = data['fingerprint']

          true
        end

        def destroy
          requires :name

          connection.delete_ssh_key_pair name

          true
        end

      end
    end
  end
end
