require 'yaml'

module Fog
  require 'fog/core/deprecation'

  # Assign a new credential to use from configuration file
  #   @param [String, Symbol] new_credential name of new credential to use
  #   @ return [String, Symbol] name of the new credential
  def self.credential=(new_credential)
    @credentials = nil
    @credential = new_credential
  end

  # @return [String, Symbol] The credential to use in Fog
  def self.credential
    @credential ||= :default
  end

  # @return [String] The path for configuration_file
  def self.credentials_path
    @credential_path ||= begin
      path = ENV["FOG_RC"] || (ENV['HOME'] && '~/.fog')
      File.expand_path(path) if path
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
        (credentials && credentials[credential]) or raise LoadError.new(missing_credentials)
      else
        {}
      end
    end
  end
  
  def self.symbolize_credentials(args)
    if args.is_a? Hash
      Hash[ args.collect do |key, value|
        [key.to_sym, self.symbolize_credentials(value)]
      end ]
    else
      args
    end
  end

private

  # @return [String] The error message that will be raised, if credentials cannot be found
  def self.missing_credentials
    <<-YML
Missing Credentials

To run as '#{credential}', add the following to your resource config file: #{credentials_path}
An alternate file may be used by placing its path in the FOG_RC environment variable

#######################################################
# Fog Credentials File
#
# Key-value pairs should look like:
# :aws_access_key_id:                 022QF06E7MXBSAMPLE
:#{credential}:
  :aws_access_key_id:
  :aws_secret_access_key:
  :bluebox_api_key:
  :bluebox_customer_id:
  :brightbox_client_id:
  :brightbox_secret:
  :go_grid_api_key:
  :go_grid_shared_secret:
  :google_storage_access_key_id:
  :google_storage_secret_access_key:
  :linode_api_key:
  :local_root:
  :new_servers_password:
  :new_servers_username:
  :public_key_path:
  :private_key_path:
  :rackspace_api_key:
  :rackspace_username:
  :rackspace_servicenet:
  :rackspace_cdn_ssl:
  :slicehost_password:
  :terremark_username:
  :terremark_password:
  :voxel_api_key:
  :voxel_api_secret:
  :zerigo_email:
  :zerigo_token:
  :dnsimple_email:
  :dnsimple_password:
#
# End of Fog Credentials File
#######################################################

YML
  end
end
