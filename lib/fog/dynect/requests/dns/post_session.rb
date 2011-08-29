module Fog
  module DNS
    class Dynect
      class Real

        def post_session
          request(
            :expects  => 200,
            :method   => :post,
            :path     => "Session",
            :body     => MultiJson.encode({
              :customer_name  => @dynect_customer,
              :user_name      => @dynect_username,
              :password       => @dynect_password
            })
          )
        end
      end

      class Mock
        def post_session
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "success",
            "data" => {
              "token" => auth_token,
              "version" => Fog::Dynect::Mock.version
            },
            "job_id" => Fog::Dynect::Mock.job_id,
            "msgs"=>[{
              "INFO"=>"login: Login successful",
              "SOURCE"=>"BLL",
              "ERR_CD"=>nil,
              "LVL"=>"INFO"
            }]
          }
          response
        end
      end
    end
  end
end
