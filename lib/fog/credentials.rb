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
          print("\n  To run as '#{credential}', add the following to ~/.fog\n")
          yml = <<-YML

:#{credential}:
  :aws_access_key_id:     INTENTIONALLY_LEFT_BLANK
  :aws_secret_access_key: INTENTIONALLY_LEFT_BLANK
  :local_root:            INTENTIONALLY_LEFT_BLANK
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

  end
end
