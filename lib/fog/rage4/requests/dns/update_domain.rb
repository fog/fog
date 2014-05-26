module Fog
  module DNS
    class Rage4
      class Real
        # Update an existing domain
        # ==== Parameters
        # * id<~Integer> - domain integer value
        # * email <~String> - email of domain owner
        # * nsprefix<~String> - vanity ns prefix (nullable)
        # * nsname<~String> - vanity ns domain name (nullable)
        # * enablevanity<~String> - activate/deactivate
        # * failover<~Boolean> - failover enable
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>
        def update_domain(id, options = {})
          email = options[:email] || @rage4_email

          path = "/rapi/updatedomain/#{id}?email=#{email}"

          path << "&nsname=#{options[:nsname]}"              if options[:nsname]
          path << "&nsprefix=#{options[:nsprefix]}"          if options[:nsprefix]
          path << "&enablevanity=#{options[:enablevanity]}"  if options[:enablevanity]
          path << "&failover=#{options[:failover]}"          if options[:failover]

          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     =>  path
          )
        end
      end
    end
  end
end
