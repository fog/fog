module Fog
  module Compute
    class HP
      class Real

        def get_windows_password(server_id, private_key_data)
          begin
            # get console output assuming that the server is already in active state
            log_output = get_console_output(server_id, 400).body['output']
            # decrypt the log output to extract the password
            encrypted_text = extract_password_from_log(log_output)
            if encrypted_text
              password = decrypt_using_private_key(encrypted_text, private_key_data)
            else
              raise "Error in extracting encrypted password from the log."
            end
          rescue OpenSSL::PKey::RSAError => error
            raise "Error in decrypting password. Exception: #{error}"
          end
          # return the password
          password
        end

      end

      class Mock

        def get_windows_password(server_id, private_key_data)
          # need to mock out the private key as well
          private_key = OpenSSL::PKey::RSA.generate(1024)
          public_key = private_key.public_key
          ### The original password is Passw0rd
          encoded_password = encrypt_using_public_key("Passw0rd", public_key)

          if list_servers_detail.body['servers'].detect {|_| _['id'] == server_id}
            begin
              # mock output for this call get_console_output(server_id, 400).body['output']
              log_output = "start junk [cloud-init] Encrypt random password\n-----BEGIN BASE64-ENCODED ENCRYPTED PASSWORD-----\n#{encoded_password}-----END BASE64-ENCODED ENCRYPTED PASSWORD-----\nend junk [cloud-init] Done\n"
              encrypted_text = extract_password_from_log(log_output)
              if encrypted_text
                password = decrypt_using_private_key(encrypted_text, private_key)
              else
                raise "Error in extracting encrypted password from the log."
              end
            rescue OpenSSL::PKey::RSAError => error
              raise "Error in decrypting password. Exception: #{error}"
            end
            # return the password should match Passw0rd
            password
          else
            raise Fog::Compute::HP::NotFound
          end
        end
      end
    end
  end
end