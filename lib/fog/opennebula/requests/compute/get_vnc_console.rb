require_relative 'OpenNebulaVNC'
module Fog
  module Compute
    class OpenNebula
      class Mock
        # Get a vnc console for an instance.
        #
        # === Parameters
        # * server_id <~String> - The ID of the server.
        # * console_type <~String> - Type of vnc console to get ('novnc' or 'xvpvnc').
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>:
        #     * url <~String>
        #     * type <~String>
        def get_vnc_console(server_id, console_type)
          body = {
#            'os-getVNCConsole' => {
#              'type' => console_type
#            }
              :type => "novnc",
              :proxy_port => "29876",
              :password => "null",
              :token => "3n32dtwpsdj5jkug3b4w",
              :proxy_host => "one.adm.netways.de"
          }
#          server_action(server_id, body)
        end # def get_vnc_console
      end # class Real

      class Real 
        def get_vnc_console(server_id, console_type, onevm_object)
          logger = Fog::Logger.new
	  $conf = {"vnc_proxy_port" => "29876", "vnc_proxy_ipv6" => "", "vnc_proxy_support_wss" => "", "vnc_proxy_cert" => "", "vnc_proxy_key" => ""}
          $vnc = OpenNebulaVNC.new($conf, logger)
	  puts server_id.inspect
          ret = startvnc(onevm_object,$vnc)

          response = Excon::Response.new
          response.status = ret[0]
          response.body = ret[1]
#            :type => "novnc",
#	          :proxy_port => "29876",
#	          :password => "null",
#	          :token => "3n32dtwpsdj5jkug3b4w",
#	        #:proxy_host => "one.adm.netways.de"
#          }
          response
        end # def get_vnc_console

        def startvnc(onevm_object, vnc)
           # resource = retrieve_resource("vm",id)
           # if OpenNebula.is_error?(resource)
           #     return [404, resource.to_json]
           # end
    
            return vnc.proxy(onevm_object)
        end #def startvnc


      end # class Mock
    end # class OpenNebula
  end # module Compute
end # module Fog

