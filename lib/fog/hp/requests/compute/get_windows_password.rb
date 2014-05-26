module Fog
  module Compute
    class HP
      class Real
        # Retrieves the encrypted administrator password for a server running Windows.
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of server
        #
        # ==== Returns
        # * password_data<~string>: Encrypted password for a server running Windows
        #
        def get_windows_password(server_id)
          # get console output assuming that the server is already in active state
          log_output = get_console_output(server_id, 400).body['output']
          # decrypt the log output to extract the encrypted, base64-encoded password
          encrypted_password = extract_password_from_log(log_output)
        end
      end

      class Mock
        def get_windows_password(server_id)
          # need to mock out the private key as well
          private_key = OpenSSL::PKey::RSA.generate(1024)
          public_key = private_key.public_key
          ### The original password is Passw0rd
          encoded_password = encrypt_using_public_key("Passw0rd", public_key)

          if list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            # mock output for this call get_console_output(server_id, 400).body['output']
            log_output = "start junk [cloud-init] Encrypt random password\n-----BEGIN BASE64-ENCODED ENCRYPTED PASSWORD-----\n#{encoded_password}-----END BASE64-ENCODED ENCRYPTED PASSWORD-----\nend junk [cloud-init] Done\n"
            encrypted_password = extract_password_from_log(log_output)
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end
