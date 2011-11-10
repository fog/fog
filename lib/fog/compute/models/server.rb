require 'fog/core/model'

module Fog
  module Compute
    class Server < Fog::Model

      def scp(local_path, remote_path, upload_options = {})
        require 'net/scp'
        requires :public_ip_address, :username

        scp_options = {}
        scp_options[:key_data] = [private_key] if private_key
        Fog::SCP.new(public_ip_address, username, scp_options).upload(local_path, remote_path, upload_options)
      end

      def ssh(commands, options={})
        require 'net/ssh'
        requires :public_ip_address, :username

        options[:key_data] = [private_key] if private_key
        Fog::SSH.new(public_ip_address, username, options).run(commands)
      end

    end
  end
end
