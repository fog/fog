module Fog
  module Orchestration
    class OpenStack
      class Real
        def validate_template(options = {})
          request(
            :body     => Fog::JSON.encode(options),
            :expects  => [200],
            :method   => 'POST',
            :path     => 'validate'
          )
        end
      end
      class Mock
        def validate_template(options = {})
          parameters = {
            "key_name" => {
              "Default"         => "mykey",
              "Type"            =>"String",
              "Description"     =>"SSH key",
              "Label"           =>"SSH Key"
            },
            "image" => {
              "Default"         => "RedHat 7",
              "Type"            =>"String",
              "Description"     =>"",
              "Label"           =>"Image Name"
            }
          }


          response = Excon::Response.new
          response.status = 200
          response.body = {
            "Description" => "Valid Stack",
            "Parameters" => parameters
          }

          response
        end
      end
    end
  end
end
