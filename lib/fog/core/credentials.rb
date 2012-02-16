require 'pathname'
require 'yaml'

module Fog
  require 'fog/core/deprecation'

  # Assign a new credential to use from configuration file
  #   @param [String, Symbol] new_credential name of new credential to use
  #   @ return [Symbol] name of the new credential
  def self.credential=(new_credential)
    @credentials = nil
    @credential = new_credential && new_credential.to_sym
  end

  # @return [String, Symbol] The credential to use in Fog
  def self.credential
    @credential ||= ( ENV["FOG_CREDENTIAL"] && ENV["FOG_CREDENTIAL"].to_sym ) || :default
  end

  # Finds the .fog configuration file.
  #
  # @return [String] The path for configuration_file
  def self.find_credentials
    return File.expand_path(ENV['FOG_RC']) if ENV['FOG_RC']

    Pathname.pwd.ascend do |dir|
      path = dir.join('.fog')

      return path if path.file?
    end

    if (ENV['HOME'] && File.directory?(ENV['HOME']))
      return File.expand_path('~/.fog')
    end
  end

  # @return [String] The current path for configuration_file
  def self.credentials_path
    @credential_path ||= begin
                           find_credentials
                         rescue
                           nil
                         end
  end

  # @return [String] The new path for credentials file
  def self.credentials_path=(new_credentials_path)
    @credentials = nil
    @credential_path = new_credentials_path
  end

  # @return [Hash] The credentials pulled from the configuration file
  # @raise [LoadError] Configuration unavailable in configuration file
  def self.credentials
    @credentials  ||= begin
      if credentials_path && File.exists?(credentials_path)
        credentials = self.symbolize_credentials(YAML.load_file(credentials_path))
        (credentials && credentials[credential]) || Fog::Errors.missing_credentials
      else
        {}
      end
    end
  end

  # @return [Hash] The newly assigned credentials
  def self.credentials=(new_credentials)
    @credentials = new_credentials
  end

  def self.symbolize_credentials(args)
    if args.is_a? Hash
      Hash[ *args.collect do |key, value|
        [key.to_sym, self.symbolize_credentials(value)]
      end.flatten ]
    else
      args
    end
  end

end
