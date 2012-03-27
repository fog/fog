module Fog
  module Storage

    def self.[](provider)
      self.new(:provider => provider)
    end

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes.delete(:provider).to_s.downcase.to_sym
      when :aws
        require 'fog/aws/storage'
        Fog::Storage::AWS.new(attributes)
      when :google
        require 'fog/google/storage'
        Fog::Storage::Google.new(attributes)
      when :ibm
        require 'fog/ibm/storage'
        Fog::Storage::IBM.new(attributes)
      when :local
        require 'fog/local/storage'
        Fog::Storage::Local.new(attributes)
      when :ninefold
        require 'fog/ninefold/storage'
        Fog::Storage::Ninefold.new(attributes)
      when :rackspace
        require 'fog/rackspace/storage'
        Fog::Storage::Rackspace.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized storage provider")
      end
    end

    def self.directories
      directories = []
      for provider in self.providers
        begin
          directories.concat(self[provider].directories)
        rescue # ignore any missing credentials/etc
        end
      end
      directories
    end

    def self.get_body_size(body)
      if body.respond_to?(:force_encoding)
        body.force_encoding('BINARY')
      end
      if body.respond_to?(:bytesize)
        body.bytesize
      elsif body.respond_to?(:size)
        body.size
      elsif body.respond_to?(:stat)
        body.stat.size
      else
        0
      end
    end

    def self.get_content_type(data)
      if data.respond_to?(:path) and !data.path.nil?
        filename = ::File.basename(data.path)
        unless (mime_types = MIME::Types.of(filename)).empty?
          mime_types.first.content_type
        end
      end
    end

    def self.parse_data(data)
      {
        :body     => data,
        :headers  => {
          'Content-Length'  => get_body_size(data),
          'Content-Type'    => get_content_type(data)
          #'Content-MD5' => Base64.encode64(Digest::MD5.digest(metadata[:body])).strip
        }
      }
    end

    def self.providers
      Fog.services[:storage]
    end

  end
end
