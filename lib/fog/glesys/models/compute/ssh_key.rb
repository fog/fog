module Fog
  module Compute
    class Glesys
      class SshKey < Fog::Model
        identity :id

        attribute :description
        attribute :data

        def save
          requires :description, :data

          merge_attributes(service.ssh_key_add(:description => description,
                                              :sshkey => data
                                             ).body["response"]["sshkey"])
          true
        end

        def destroy
          requires :id

          service.ssh_key_remove(:sshkeyids => id)
          true
        end
      end
    end
  end
end
