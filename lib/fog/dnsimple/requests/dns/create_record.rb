module Fog
  module DNS
    class DNSimple
      class Real
        # Create a new host in the specified zone
        #
        # ==== Parameters
        # * domain<~String> - domain name or numeric ID
        # * name<~String>
        # * type<~String>
        # * content<~String>
        # * options<~Hash> - optional
        #   * priority<~Integer>
        #   * ttl<~Integer>
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'record'<~Hash> The representation of the record.
        def create_record(domain, name, type, content, options = {})
          body = {
            "record" => {
              "name" => name,
              "record_type" => type,
              "content" => content
            }
          }

          body["record"].merge!(options)

          request(
            :body     => Fog::JSON.encode(body),
            :expects  => 201,
            :method   => 'POST',
            :path     => "/domains/#{domain}/records"
          )
        end
      end

      class Mock
        def create_record(domain, name, type, content, options = {})
          body = {
            "record" => {
              "id" => Fog::Mock.random_numbers(1).to_i,
              "domain_id" => domain,
              "name" => name,
              "content" => content,
              "ttl" => 3600,
              "prio" => nil,
              "record_type" => type,
              "system_record" => nil,
              "created_at" => Time.now.iso8601,
              "updated_at" => Time.now.iso8601,
            }.merge(options)
          }
          self.data[:records][domain] ||= []
          self.data[:records][domain] << body

          response = Excon::Response.new
          response.status = 201
          response.body = body
          response
        end
      end
    end
  end
end
