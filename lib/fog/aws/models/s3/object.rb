module Fog
  module AWS
    class S3

      class Object < Fog::Model

        attr_accessor :etag, :key, :last_modified, :owner, :size, :storage_class

      end

    end
  end
end
