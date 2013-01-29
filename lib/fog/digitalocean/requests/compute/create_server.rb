module Fog
  module Compute
    class DigitalOcean
      class Real

        #
        # FIXME: missing ssh keys support
        #
        def create_server( name, 
                           size_id, 
                           image_id, 
                           region_id,
                           options = {} )

          query_args = []
          query_hash = {
            :name      => name,
            :size_id   => size_id,
            :image_id  => image_id,
            :region_id => region_id
          }.each { |k, v| query_args << "#{k}=#{v}" }
          query_hash.each { |k, v| query_args << "#{k}=#{v}" }
          
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'droplets/new',
            :query    => query_hash
          )
        end

      end

      class Mock

        def create_server( name, 
                           size_id, 
                           image_id, 
                           region_id,
                           options = {} )
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
