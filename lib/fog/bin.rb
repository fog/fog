module Fog
  class << self

    def credential=(new_credential)
      @credential = new_credential
      @credentials = nil
    end

    def credential
      @credential || :default
    end

    def credentials
      @credentials ||= begin
        path = File.expand_path('~/.fog')
        credentials = if File.exists?(path)
          File.open(path) do |file|
            YAML.load(file.read)
          end
        else
          nil
        end
        unless credentials && credentials[credential]
          print("\n  To run as '#{credential}', add credentials like the following to ~/.fog\n")
          yml = <<-YML

:#{credential}:
  :aws_access_key_id:     INTENTIONALLY_LEFT_BLANK
  :aws_secret_access_key: INTENTIONALLY_LEFT_BLANK
  :rackspace_api_key:     INTENTIONALLY_LEFT_BLANK
  :rackspace_username:    INTENTIONALLY_LEFT_BLANK
  :slicehost_password:    INTENTIONALLY_LEFT_BLANK
  :terremark_username:    INTENTIONALLY_LEFT_BLANK
  :terremark_password:    INTENTIONALLY_LEFT_BLANK

YML
          print(yml)
          raise(ArgumentError.new("Missing Credentials"))
        end
        credentials[credential]
      end
    end

    def services
      services = []
      [::AWS, ::Rackspace, ::Slicehost, ::Terremark].each do |service|
        if service.initialized?
          services << service
        end
      end
      services
    end

    def flavors
      flavors = {}
      services.each do |service|
        flavors[service] = service.flavors
      end
      flavors
    end

    def images
      images = {}
      services.each do |service|
        images[service] = service.images
      end
      images
    end

    def servers
      servers = {}
      services.each do |service|
        servers[service] = service.servers
      end
      servers
    end

  end
end