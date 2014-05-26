module Fog
  module Compute
    class HP
      class Real
        # Retrieve console output for specified instance
        #
        # ==== Parameters
        # * server_id<~Integer> - Id of instance to get console output from
        # * num_lines<~Integer> - Number of lines of console output from the end
        # ==== Returns
        # # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'output'<~String> - Console output
        #
        def get_console_output(server_id, num_lines)
          body = { 'os-getConsoleOutput' => { 'length' => num_lines }}
          server_action(server_id, body, 200)
        end
      end

      class Mock
        def get_console_output(server_id, num_lines)
          output = ""
          response = Excon::Response.new
          if list_servers_detail.body['servers'].find {|_| _['id'] == server_id}
            (1..num_lines).each {|i| output += "Console Output Line #{i} \r\n"}
            response.body = { 'output' => output }
            response.status = 200
          else
            raise Fog::Compute::HP::NotFound
          end
          response
        end
      end
    end
  end
end
