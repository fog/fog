module Fog
  module Compute
    class OpenNebula
      class Real
        def image_pool(filter = { })

          images = ::OpenNebula::ImagePool.new(client)
          if filter[:mine].nil?
            images.info!
          else
            images.info_mine!
          end # if filter[:mine].nil?

          if not filter[:id].nil?
            images.each do |i|
              if filter[:id] == i.id
                return [ i ] # return an array with only one element - found image
              end
            end
          end
          images.delete nil
          images
        end #def image_pool
      end #class Real
    end #class OpenNebula
  end #module Compute
end #module Fog
