require 'fog/fogdocker/core'

module Fog
  module Compute
    class Fogdocker < Fog::Service

      requires   :docker_url
      recognizes :docker_username, :docker_password, :docker_email

      model_path 'fog/fogdocker/models/compute'
      model      :server
      collection :servers
      model      :image
      collection :images

      request_path 'fog/fogdocker/requests/compute'

      request :api_version
      request :container_all
      request :container_create
      request :container_delete
      request :container_get
      request :container_action
      request :container_commit
      request :image_all
      request :image_create
      request :image_delete
      request :image_get

      class Mock
        def initialize(options={})
        end
      end

      class Real

        def initialize(options={})
          require 'docker'
          username = options[:docker_username]
          password = options[:docker_password]
          email    = options[:docker_email]
          url      = options[:docker_url]

          Docker.url = url
          Docker.authenticate!('username' => username, 'password' => password, 'email' => email) unless username. nil? || username.empty?
        end

        def downcase_hash_keys(hash, k = [])
          return {k.join('_').gsub(/([a-z])([A-Z])/,'\1_\2').downcase => hash} unless hash.is_a?(Hash)
          hash.inject({}){ |h, v| h.merge! downcase_hash_keys(v[-1], k + [v[0]]) }
        end

        def camelize_hash_keys(hash)
          Hash[ hash.map {|k, v| [k.to_s.split('_').map {|w| w.capitalize}.join, v] }]
        end

      end
    end
  end
end
