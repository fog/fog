module Fog
  module AWS
    class IAM
      class Real
        require 'fog/aws/parsers/iam/get_account_password_policy'

        # Get Account Password Policy
        #
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #       * MinimumPasswordLength<~integer> Minimum length to require for IAM user passwords.
        #       * MaxPasswordAge<~integer> The number of days that an IAM user password is valid.
        #       * PasswordReusePrevention<~integer> Specifies the number of previous passwords that IAM users are prevented from reusing.        
        #       * RequireSymbols<~boolean> Specifies whether to require symbols for IAM user passwords.
        #       * RequireNumbers<~boolean> Specifies whether to require numbers for IAM user passwords.
        #       * RequireUppercaseCharacters<~boolean> Specifies whether to require uppercase characters for IAM user passwords.
        #       * RequireLowercaseCharacters<~boolean> Specifies whether to require lowercase characters for IAM user passwords.
        #       * AllowUsersToChangePassword<~boolean> Specifies whether IAM users are allowed to change their own password.
        #       * HardExpiry<~boolean> Specifies whether IAM users are prevented from setting a new password after their password has expired.
        #       * ExpirePasswords<~boolean> Specifies whether IAM users are required to change their password after a specified number of days.
        #
        # ==== See Also
        # http://docs.aws.amazon.com/IAM/latest/APIReference/API_GetAccountPasswordPolicy.html
        #
        def get_account_password_policy()
          request({            
            'Action'      => 'GetAccountPasswordPolicy',
            :parser       => Fog::Parsers::AWS::IAM::GetAccountPasswordPolicy.new
          })
        end
      end
    
      class Mock
        def get_account_password_policy()
          minimum_password_length, password_reuse_prevention, max_password_age = 5
          require_symbols, require_numbers, require_uppercase_characters, require_lowercase_characters, allow_users_to_change_password, hard_expiry, expire_passwords = false            
          Excon::Response.new.tap do |response|
            response.body = {
              'MinimumPasswordLength' => minimum_password_length,
              'MaxPasswordAge'      => max_password_age,
              'PasswordReusePrevention'  => password_reuse_prevention,
              'RequireSymbols'        => require_symbols,
              'RequireNumbers'        => require_numbers,
              'RequireUppercaseCharacters'        => require_uppercase_characters,
              'RequireLowercaseCharacters'        => require_lowercase_characters,
              'AllowUsersToChangePassword'        => allow_users_to_change_password,
              'HardExpiry'                        => hard_expiry,
              'ExpirePasswords'                   => expire_passwords,
              'RequestId' => Fog::AWS::Mock.request_id
            }            
            response.status = 200
          end
        end
      end
    end
  end
end
