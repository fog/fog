module Fog
  module DNS
    class DNSimple
      class Real

        # Create a new host in the specified zone
        #
        # ==== Parameters
        # * domain<~String>
        # * name<~String>
        # * type<~String>
        # * content<~String>
        # * options<~Hash> - optional
        #   * priority<~Integer>
        #   * ttl<~Integer>
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        #     * name<~String>
        #     * ttl<~Integer>
        #     * created_at<~String>
        #     * special_type<~String>
        #     * updated_at<~String>
        #     * domain_id<~Integer>
        #     * id<~Integer>
        #     * content<~String>
        #     * record_type<~String>
        #     * prio<~Integer>
        def create_record(domain, name, type, content, options = {})

          body = {
            "record" => {
              "name" => name,
              "record_type" => type,
              "content" => content } }

          body["record"].merge!(options)

          request( :body     => Fog::JSON.encode(body),
                   :expects  => 201,
                   :method   => 'POST',
                   :path     => "/domains/#{domain}/records" )
        end

      end

      class Mock

        def create_record(domain, name, type, content, options = {})
          response = Excon::Response.new
          response.status = 201
          body = {
            "record" => {
              "name" => name,
              "record_type" => type,
              "content" => content,
              "created_at" => Time.now.iso8601,
              "updated_at" => Time.now.iso8601,
              "id" => Fog::Mock.random_numbers(1).to_i,
              "domain_id" => domain
            }.merge(options)
          }

          self.data[:records][domain] ||= []
          self.data[:records][domain] << body

          response.body = body
          response
        end

      end

    end
  end
end
