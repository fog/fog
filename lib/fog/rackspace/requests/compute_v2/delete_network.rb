module Fog
  module Compute
    class RackspaceV2
      class Real
        def delete_network(id)
          request(:method => 'DELETE', :path => "os-networksv2/#{id}", :expects => 202)
        end
      end

      class Mock
        def delete_network(id)
          unless self.data[:networks].key?(id)
            raise Fog::Compute::RackspaceV2::NotFound
          end

          response(:body => '', :status => 202)
        end
      end
    end
  end
end
