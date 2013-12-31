module Fog
  module Compute
    class Cloudstack

      class KeyPair < Fog::Model

        identity  :name

        attribute :fingerprint
        attribute :private_key,                           :aliases => 'privatekey'

        def destroy
          requires :name

          service.delete_ssh_key_pair(name)
          true
        end

        def save
          requires :name

          data = service.create_ssh_key_pair(name)

          merge_attributes(data['createsshkeypairresponse']['keypair'])
        end

        def write(path="#{ENV['HOME']}/.ssh/fog_#{Fog.credential.to_s}_#{name}.pem")

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
          !!(private_key && ENV.has_key?('HOME'))
        end

      end
    end
  end
end
