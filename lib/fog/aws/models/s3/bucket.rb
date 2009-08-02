module Fog
  module AWS
    class S3

      class Bucket < Fog::Model

        attr_accessor :creation_date, :name, :owner

      end

    end
  end
end
