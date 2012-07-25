require 'fog/core/model'

module Fog
  module Compute
    class Server < Fog::Model

      def private_key=(key_data)
        @private_key = key_data
      end

      def scp(local_path, remote_path, upload_options = {})
        require 'net/scp'
        requires :public_ip_address, :username

        scp_options = {:port => ssh_port}
        scp_options[:key_data] = [private_key] if private_key
        Fog::SCP.new(public_ip_address, username, scp_options).upload(local_path, remote_path, upload_options)
      end

      alias_method :scp_upload, :scp

      def scp_download(remote_path, local_path, download_options = {})
        require 'net/scp'
        requires :public_ip_address, :username

        scp_options = {:port => ssh_port}
        scp_options[:key_data] = [private_key] if private_key
        Fog::SCP.new(public_ip_address, username, scp_options).download(remote_path, local_path, download_options)
      end

      def ssh(commands, options={}, &blk)
        require 'net/ssh'
        requires :public_ip_address, :username

        options[:key_data] = [private_key] if private_key
        options[:port] ||= ssh_port
        Fog::SSH.new(public_ip_address, username, options).run(commands, &blk)
      end

      def ssh_port
        22
      end

      def sshable?
        ready? && !public_ip_address.nil? && !!Timeout::timeout(8) { ssh 'pwd' }
      rescue SystemCallError, Net::SSH::AuthenticationFailed, Timeout::Error
        false
      end

    end
  end
end
