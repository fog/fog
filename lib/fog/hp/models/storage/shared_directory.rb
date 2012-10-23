require 'fog/core/model'
require 'fog/hp/models/storage/shared_files'

module Fog
  module Storage
    class HP

      class SharedDirectory < Fog::Model

        identity  :url

        attribute :bytes, :aliases => 'X-Container-Bytes-Used'
        attribute :count, :aliases => 'X-Container-Object-Count'

        def files
          @files ||= begin
            Fog::Storage::HP::SharedFiles.new(
              :shared_directory    => self,
              :connection          => connection
            )
          end
        end

      end

    end
  end
end
