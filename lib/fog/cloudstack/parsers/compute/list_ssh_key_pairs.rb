module Fog
  module Parsers
    module Compute
      module Cloudstack

        class ListSshKeyPairs < Fog::Parsers::Base

          def reset
            @response = { 'keyPairs' => [] }
            @key_pair = {}
          end

          def start_element(name, attr = [])
            super
          end

          def end_element(name)
            case name
            when 'name', 'fingerprint','privatekey'
              @key_pair[name] = value
            when 'sshkeypair'
              @response['keyPairs'] << @key_pair
              @key_pair = {}
            end
          end

        end
      end
    end
  end
end
