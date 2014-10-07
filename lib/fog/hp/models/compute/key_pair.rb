require 'fog/core/model'

module Fog
  module Compute
    class HP
      class KeyPair < Fog::Model
        identity  :name

        attribute :fingerprint
        attribute :public_key
        attribute :private_key
        attribute :user_id

        def destroy
          requires :name
          service.delete_key_pair(name)
          true
        end

        def save
          requires :name
          data = if public_key
            service.create_key_pair(name, public_key).body['keypair']
          else
            service.create_key_pair(name).body['keypair']
          end
          new_attributes = data.reject {|key,value| !['fingerprint', 'public_key', 'name', 'private_key', 'user_id'].include?(key)}
          merge_attributes(new_attributes)
          true
        end

        def write(path="#{ENV['HOME']}/.ssh/hp_#{Fog.credential.to_s}_#{name}.pem")
          if writable?
            split_private_key = private_key.split(/\n/)
            File.open(path, "w") do |f|
              split_private_key.each {|line| f.puts line}
              f.chmod 0600
            end
            "Key file built: #{path}"
          else
            "Invalid private key"
          end
        end

        def writable?
          !!(private_key && ENV.key?('HOME'))
        end
      end
    end
  end
end
