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

    def self.get_body_size(body)
      case
      when body.respond_to?(:bytesize)
        body.bytesize
      when body.respond_to?(:size)
        body.size
      when body.respond_to?(:stat)
        body.stat.size
      else
        0
      end
    end
    
    def self.parse_data(data)
      metadata = {
        :body => nil,
        :headers => {}
      }
      
      metadata[:body] = data
      metadata[:headers]['Content-Length'] = get_body_size(data)
      
      if data.respond_to?(:path)
        filename = ::File.basename(data.path)
        unless (mime_types = MIME::Types.of(filename)).empty?
          metadata[:headers]['Content-Type'] = mime_types.first.content_type
        end
      end
      # metadata[:headers]['Content-MD5'] = Base64.encode64(Digest::MD5.digest(metadata[:body])).strip
      metadata
    end
    
  end
end
