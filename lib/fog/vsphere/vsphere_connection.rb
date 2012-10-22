require 'rbvmomi'
require 'digest/sha2'

module Fog
class VsphereConnection

  def self.connect(options={})
 
    connection = nil
 
    if not options[:cert]
      connection = login_by_user options
    else
      connection = login_by_certificate options
    end

    connection
  end

  def self.login_by_certificate(options={})
    connection = nil

    # The endpoint to talk to behind the vCenter reverse proxy is 
    # https://sdkTunnel:8089/sdk/vimService. It is the same URL on all
    # vCenter servers.

    # This is a state variable to allow digest validation of the SSL cert
    bad_cert = false
    loop do
    begin
      connection = RbVmomi::VIM.new :proxyHost => options[:vsphere_server],
                                    :proxyPort => options[:vsphere_proxyport] || 80,
                                    :host => 'sdkTunnel',
                                    :port => 8089,
                                    :path => '/sdk/vimService',
                                    :ns   => options[:vsphere_ns] || 'urn:vim25',
                                    :rev  => options[:vsphere_rev] || '4.0',
                                    :ssl  => options[:vsphere_ssl] || true,
                                    :cert => File.read(options[:cert]),
                                    :key  => File.read(options[:key]),
                                    :insecure => !(options[:vsphere_verify_cert] || false)
      break
    rescue OpenSSL::SSL::SSLError
      raise if bad_cert
      bad_cert = true
    end
    end

    return nil if connection.nil?

    validate_ssl_connection connection, options if bad_cert

    negotiate_ver(connection, options)

    begin
      connection.serviceContent.sessionManager.LoginExtensionByCertificate :extensionKey => options[:extension_key]
    rescue RbVmomi::VIM::InvalidLogin => e
puts "cert:#{options[:cert]} key:#{options[:key]} ek:#{options[:extension_key]}"
      raise Fog::Vsphere::Errors::ServiceError, e.message
    end

    connection
  end

  def self.login_by_user(options={})
    connection = nil

    # This is a state variable to allow digest validation of the SSL cert
    bad_cert = false
    loop do
    begin
      connection = RbVmomi::VIM.new :host => options[:vsphere_server],
                                    :port => options[:vsphere_port] || 443,
                                    :path => options[:vsphere_path] || '/sdk',
                                    :ns   => options[:vsphere_ns] || 'urn:vim25',
                                    :rev  => options[:vsphere_rev] || '4.0',
                                    :ssl  => options[:vsphere_ssl] || true,
                                    :insecure => !(options[:vsphere_verify_cert] || false)
      break
    rescue OpenSSL::SSL::SSLError
      raise if bad_cert
      bad_cert = true
    end
    end

    return nil if connection.nil?

    validate_ssl_connection connection, options if bad_cert

    negotiate_ver(connection, options)

    begin
      connection.serviceContent.sessionManager.Login :userName => options[:vsphere_username],
                                                     :password => options[:vsphere_password]
    rescue RbVmomi::VIM::InvalidLogin => e
      raise Fog::Vsphere::Errors::ServiceError, e.message
    end

    connection
  end

  def self.negotiate_ver(conn, options={})
    if not options[:vsphere_rev]
      rev = conn.serviceContent.about.apiVersion
      conn.rev = [ rev, ENV['FOG_VSPHERE_REV'] || '4.1' ].min
    end
  end

  def self.validate_ssl_connection(conn, options={})
    pubkey = conn.http.peer_cert.public_key
    pubkey_hash = Digest::SHA2.hexdigest(pubkey.to_s)
    expected_pubkey_hash = options[:vsphere_expected_pubkey_hash]
    if pubkey_hash != expected_pubkey_hash then
      raise Fog::Vsphere::Errors::SecurityError, "The remote system presented a public key with hash #{pubkey_hash} but we're expecting a hash of #{expected_pubkey_hash || '<unset>'}. If you are sure the remote system is authentic set vsphere_expected_pubkey_hash: <the hash printed in this message> in ~/.fog"
    end
  end

end
end
