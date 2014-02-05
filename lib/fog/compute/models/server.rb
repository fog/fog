require 'fog/core/model'

module Fog
  module Compute
    class Server < Fog::Model

      attr_writer :username, :private_key, :private_key_path, :public_key, :public_key_path, :ssh_port, :ssh_options

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

      # Port used for ssh/scp interactions with server.
      # @return [Integer] IP port
      # @note By default this returns 22
      def ssh_port
        @ssh_port ||= 22
      end

      # Sets the proc used to determine the IP Address used for ssh/scp interactions.
      # @example
      #   service.servers.bootstrap :name => 'bootstrap-server',
      #                             :flavor_id => service.flavors.first.id,
      #                             :image_id => service.images.find {|img| img.name =~ /Ubuntu/}.id,
      #                             :public_key_path => '~/.ssh/fog_rsa.pub',
      #                             :private_key_path => '~/.ssh/fog_rsa',
      #                             :ssh_ip_address => Proc.new {|server| server.private_ip_address }
      #
      # @note By default scp/ssh will use the public_ip_address if this proc is not set.
      def ssh_ip_address=(proc)
        @ssh_ip_address = proc
      end

      # IP Address used for ssh/scp interactions with server.
      # @return [String] IP Address
      # @note By default this returns the public_ip_address
      def ssh_ip_address
        return public_ip_address unless @ssh_ip_address
        return @ssh_ip_address.call(self) if @ssh_ip_address.is_a?(Proc)
        @ssh_ip_address
      end

      def ssh_options
        @ssh_options ||= {}
        ssh_options = @ssh_options.merge({:port => ssh_port})
        if private_key
          ssh_options[:key_data] = [private_key]
          ssh_options[:auth_methods] = ["publickey"]
        end
        ssh_options
      end

      def scp(local_path, remote_path, upload_options = {})
        require 'net/scp'
        requires :ssh_ip_address, :username

        Fog::SCP.new(ssh_ip_address, username, ssh_options).upload(local_path, remote_path, upload_options)
      end

      alias_method :scp_upload, :scp

      def scp_download(remote_path, local_path, download_options = {})
        require 'net/scp'
        requires :ssh_ip_address, :username

        Fog::SCP.new(ssh_ip_address, username, ssh_options).download(remote_path, local_path, download_options)
      end

      def ssh(commands, options={}, &blk)
        require 'net/ssh'
        requires :ssh_ip_address, :username

        options = ssh_options.merge(options)

        Fog::SSH.new(ssh_ip_address, username, options).run(commands, &blk)
      end

      def sshable?(options={})
        ready? && !ssh_ip_address.nil? && !!Timeout::timeout(8) { ssh('pwd', options) }
      rescue SystemCallError, Net::SSH::AuthenticationFailed, Net::SSH::Disconnect, Timeout::Error
        false
      end

    end
  end
end
