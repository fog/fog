module Fog
  module Rackspace
    class Files

      class Directory < Fog::Model

        identity  :name

        attribute :bytes
        attribute :count

        def destroy
          requires :name
          connection.delete_container(@name)
          true
        rescue Excon::Errors::NotFound
          false
        end

        def files
          @files ||= begin
            Fog::Rackspace::Files::Files.new(
              :directory    => self,
              :connection   => connection
            )
          end
        end

        def save
          requires :name
          connection.put_container(@name)
          true
        end

      end

    end
  end
end
