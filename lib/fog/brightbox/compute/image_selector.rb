module Fog
  module Brightbox
    module Compute
      #
      # This selects the preferred image to use based on a number of
      # conditions
      #
      class ImageSelector
        # Prepares a selector with the API output
        #
        # @param [Array<Hash>] images hash matching API output for {Fog::Compute::Brightbox#list_images}
        #
        def initialize(images)
          @images = images
        end

        # Returns current identifier of the latest version of Ubuntu
        #
        # The order of preference is:
        # * Only Official Brightbox images
        # * Only Ubuntu images
        # * Latest by name (alphanumeric sort)
        # * Latest by creation date
        #
        # @note This performs a live query against the API
        #
        # @return [String] if image matches containing the identifier
        # @return [NilClass] if no image matches
        #
        def latest_ubuntu
          @images.select do |img|
            img["official"] == true &&
              img["arch"] == "i686" &&
              img["name"] =~ /ubuntu/i
          end.sort do |a, b|
            # Reverse sort so "raring" > "precise" and "13.10" > "13.04"
            b["name"].downcase <=> a["name"].downcase
          end.first["id"]
        rescue
          nil
        end
      end
    end
  end
end
