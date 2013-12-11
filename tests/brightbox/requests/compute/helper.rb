class Brightbox
  module Compute
    module TestSupport
      # Find a suitable image for testing with
      # For speed of server building we're using an empty image
      #
      # Unless the tester has credentials this will fail so we rescue
      # any errors and return nil.
      #
      # This is used in the shared file +tests/compute/helper.rb+ so unfortunately
      # makes all tests reliant on hardcoded values and each other
      #
      # @return [String,NilClass] the most suitable test image's identifier or nil
      def self.image_id
        return @image_id unless @image_id.nil?
        image = select_testing_image_from_api
        @image_id = image["id"]
      rescue
        @image_id = nil
      end

      # Prepare a test server, wait for it to be usable but raise if it fails
      def self.get_test_server
        test_server_options = {:image_id => image_id}
        server = Fog::Compute[:brightbox].servers.create(test_server_options)
        server.wait_for {
          raise "Test server failed to build" if state == "failed"
          ready?
        }
        server
      end

    private
      def self.select_testing_image_from_api
        images = Fog::Compute[:brightbox].list_images
        raise "No available images!" if images.empty?
        images.select { |img| img["official"] && img["virtual_size"] != 0 }.sort_by { |img| img["disk_size"] }.first || images.first
      end
    end
  end
end
