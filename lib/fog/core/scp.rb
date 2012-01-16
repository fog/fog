module Fog
  module SCP

    def self.new(address, username, options = {})
      if Fog.mocking?
        Fog::SCP::Mock.new(address, username, options)
      else
        Fog::SCP::Real.new(address, username, options)
      end
    end

    class Mock

      def self.data
        @data ||= Hash.new do |hash, key|
          hash[key] = {}
        end
      end

      def initialize(address, username, options)
        @address  = address
        @username = username
        @options  = options
      end

      def upload(local_path, remote_path, upload_options = {})
        Fog::Mock.not_implemented
      end

      def download(remote_path, local_path, download_options = {})
        Fog::Mock.not_implemented
      end

    end

    class Real

      def initialize(address, username, options)
        require 'net/scp'

        key_manager = Net::SSH::Authentication::KeyManager.new(nil, options)

        unless options[:key_data] || options[:keys] || options[:password] || key_manager.agent
          raise ArgumentError.new(':key_data, :keys, :password or a loaded ssh-agent is required to initialize SSH')
        end

        @address  = address
        @username = username
        @options  = { :paranoid => false }.merge(options)
      end

      def upload(local_path, remote_path, upload_options = {})
        begin
          Net::SCP.start(@address, @username, @options) do |scp|
            scp.upload!(local_path, remote_path, upload_options) do |ch, name, sent, total|
              # TODO: handle progress display?
            end
          end
        rescue Exception => error
          raise error
        end
      end

      def download(remote_path, local_path, download_options = {})
        begin
          Net::SCP.start(@address, @username, @options) do |scp|
            scp.download!(remote_path, local_path, download_options) do |ch, name, sent, total|
              # TODO: handle progress display?
            end
          end
        rescue Exception => error
          raise error
        end
      end

    end

  end
end
