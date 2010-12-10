require 'yaml'

module Fog
  # Assign a new set of credentials for use in Fog
  #   @param [String, Symbol] new_credential The name of the new credential to use in Fog
  #   @ return [String, Symbol] The name of the new Fog credential
  def self.credential=(new_credential)
    @credentials  = nil
    @credential   = new_credential
  end

  # @return [String, Symbol] The credential in use by Fog
  def self.credential
    @credential ||= :default
  end

  # @return [String] The credential's configuration path, read by Fog
  def self.config_path
    File.expand_path(ENV["FOG_RC"] || '~/.fog')
  end

  # @return [Hash] The credentials pulled from the config_path file
  def self.credentials
    @credentials  ||= parse_config
  end

  # @return [Hash] The credentials pulled from the config_path file
  # @raise [LoadError] Incorrect credential for config file
  def self.parse_config
    config = YAML.load_file(config_path)

    if config && config[credential]
      return config[credential]
    else
      raise LoadError.new missing_credentials
    end
  end

private
  # @param [String] _cred The name of the credential being used
  # @param [String] _path Resource Config File's Path
  # @return [String] The error message that will be raised, if credentials cannot be found
  def self.missing_credentials <<-YML
Missing Credentials

To run as '#{credential}', add the following to your resource config file: #{config_path}
An alternate file may be used by placing its path in the FOG_RC environment variable

#######################################################
# Fog Resource Config File
#
# Key-value pairs should look like:
# :aws_access_key_id:                022QF06E7MXBSAMPLE
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
  :local_root:                       
  :new_servers_password:             
  :new_servers_username:             
  :public_key_path:                  
  :private_key_path:                 
  :rackspace_api_key:                
  :rackspace_username:               
  :slicehost_password:               
  :terremark_username:               
  :terremark_password:               
#
# End of Fog Resource Config File
#######################################################

YML
  end
end
