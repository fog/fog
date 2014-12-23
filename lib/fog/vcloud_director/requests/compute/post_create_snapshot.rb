module Fog
  module Compute
    class VcloudDirector
      class Real
        # Creates new snapshot of a virtual machine or of all the virtual machines in a vApp.
        # Prior to creation of the new snapshots, any existing user created snapshots associated
        # with the virtual machines are removed.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp or virtual machine.
        # @param [Hash] options
        # @option options [String] :name Typically used to name or identify the subject of the request.
        #   For example, the name of the object being created or modified.
        # @option options [Boolean] :memory True if the snapshot should include the virtual machine's memory.
        # @option options [Boolean] :quiesce True if the file system of the virtual machine should be quiesced
        #   before the snapshot is created.
        # @option options [String] :description Optional description.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CreateSnapshot.html
        # @since vCloud API version 5.1
        def post_create_snapshot(id, options = {})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5'
            }
            attrs[:name] = options[:name] if options.key?(:name)
            attrs[:memory] = options[:memory] if options.key?(:memory)
            attrs[:quiesce] = options[:quiesce] if options.key?(:quiesce)
            CreateSnapshotParams(attrs) { Description options[:description] if options.key?(:description) }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.createSnapshotParams+xml' },
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/action/createSnapshot"
          )
        end
      end
    end
  end
end
