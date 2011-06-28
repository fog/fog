require 'fog/core/model'

module Fog
  module Storage
    class Ninefold

      class Directory < Fog::Model

        identity :filename, :aliases => [:'Filename', :'key']
        attribute :id, :aliases => :'ObjectID'
        attribute :type, :aliases => :'FileType'

        def save
          res = connection.post_namespace filename
          reload
        end

        def destroy
          connection.delete_namespace filename
        end


      end

    end
  end
end
