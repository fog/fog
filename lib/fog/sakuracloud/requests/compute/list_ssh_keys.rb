# coding: utf-8

module Fog
  module Compute
    class SakuraCloud
      class Real
        def list_ssh_keys(options = {})
          request(
            :headers => {
              'Authorization' => "Basic #{@auth_encord}"
            },
            :method => 'GET',
            :path => "#{Fog::SakuraCloud::SAKURACLOUD_API_ENDPOINT}/sshkey"
          )
        end
      end

      class Mock
        def list_ssh_keys(options = {})
          response = Excon::Response.new
          response.status = 200
          response.body = {
          "SSHKeys"=>
            [
            {"Index"=>0,
              "ID"=>"888888888888",
              "Name"=>"foobar1",
              "PublicKey"=>"ssh-rsa dummy"},
            {"Index"=>1,
              "ID"=>"999999999999",
              "Name"=>"foobar2",
              "PublicKey"=>"ssh-rsa dummy"}
            ]
          }
          response
        end
      end
    end
  end
end
