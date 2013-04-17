require 'fog/core/model'

module Fog
  module Compute
    class Server < Fog::Model

      attr_writer :username, :private_key, :private_key_path, :public_key, :public_key_path, :ssh_port

      def username
        @username ||= 'root'
      end

      def private_key_path
        @private_key_path ||= Fog.credentials[:private_key_path]
        @private_key_path &&= File.expand_path(@private_key_path)
      end

      def private_key
        @private_key ||= private_key_path && File.read(private_key_path)
      end

      def public_key_path
        @public_key_path ||= Fog.credentials[:public_key_path]
        @public_key_path &&= File.expand_path(@public_key_path)
      end

      def public_key
        @public_key ||= public_key_path && File.read(public_key_path)
      end

      def ssh_port
        @ssh_port ||= 22
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

      def sshable?(options={})
        ready? && !public_ip_address.nil? && !!Timeout::timeout(8) { ssh('pwd', options) }
      rescue SystemCallError, Net::SSH::AuthenticationFailed, Timeout::Error
        false
      end

    end
  end
end
