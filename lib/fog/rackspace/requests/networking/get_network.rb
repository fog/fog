module Fog
  module Rackspace
    class Networking
      class Real
        def get_network(id)
          request(:method => 'GET', :path => "os-networksv2/#{id}", :expects => 200)
        end
      end

      class Mock
        def get_network(id)
          unless self.data[:networks].key?(id)
            raise Fog::Rackspace::Networking::NotFound
          end

          response(:body => { 'network' => self.data[:networks][id] })
        end
      end
    end
  end
end
