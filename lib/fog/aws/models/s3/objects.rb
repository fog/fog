module Fog
  module AWS
    class S3

      class Objects < Fog::Collection

        attr_accessor :is_truncated, :marker, :max_keys, :name, :prefix

      end

    end
  end
end
