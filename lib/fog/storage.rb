module Fog
  class Storage

    def self.new(attributes)
      attributes = attributes.dup # prevent delete from having side effects
      case provider = attributes[:provider] # attributes.delete(:provider)
      when 'AWS'
        require 'fog/storage/aws'
        Fog::AWS::Storage.new(attributes)
      when 'Google'
        require 'fog/storage/google'
        Fog::Google::Storage.new(attributes)
      when 'Local'
        require 'fog/storage/local'
        Fog::Local::Storage.new(attributes)
      when 'Rackspace'
        require 'fog/storage/rackspace'
        Fog::Rackspace::Storage.new(attributes)
      else
        raise ArgumentError.new("#{provider} is not a recognized storage provider")
      end
    end

    def self.parse_data(data)
      metadata = {
        :body => nil,
        :headers => {}
      }

      if data.is_a?(String)
        metadata[:body] = data
        metadata[:headers]['Content-Length'] = metadata[:body].size
      else
        filename = ::File.basename(data.path)
        unless (mime_types = MIME::Types.of(filename)).empty?
          metadata[:headers]['Content-Type'] = mime_types.first.content_type
        end
        metadata[:body] = data
        metadata[:headers]['Content-Length'] = ::File.size(data.path)
      end
      # metadata[:headers]['Content-MD5'] = Base64.encode64(Digest::MD5.digest(metadata[:body])).strip
      metadata
    end

  end
end