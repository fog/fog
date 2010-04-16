module Fog
  module Terremark
   module Ecloud

     module Bin
     end

     extend Fog::Terremark::Shared

     def self.new(options={})

       unless @required
         shared_requires
         @required = true
       end

       check_shared_options(options)

       if Fog.mocking?
          Fog::Terremark::Ecloud::Mock.new(options)
        else
          Fog::Terremark::Ecloud::Real.new(options)
        end
     end

     class Real

       include Fog::Terremark::Shared::Real
       include Fog::Terremark::Shared::Parser

        def initialize(options={})
          @terremark_password = options[:terremark_ecloud_password]
          @terremark_username = options[:terremark_ecloud_username]
          @host   = options[:host]   || "services.enterprisecloud.terremark.com"
          @path   = options[:path]   || "/api/v0.8a-ext2.0"
          @port   = options[:port]   || 443
          @scheme = options[:scheme] || 'https'
          @cookie = get_organizations.headers['Set-Cookie']
        end

      end

     class Mock
       include Fog::Terremark::Shared::Mock
       include Fog::Terremark::Shared::Parser
     end

    end
  end
end

