require 'fog/openvz/core'

module Fog
  module Compute
    class Openvz < Fog::Service
      recognizes   :openvz_connect_command

      model_path   'fog/openvz/models/compute'
      model        :server
      collection   :servers

      request_path 'fog/openvz/requests/compute'
      request      :list_servers
      request      :get_server_details

      request      :create_server
      request      :start_server
      request      :destroy_server
      request      :mount_server
      request      :umount_server
      request      :stop_server
      request      :restart_server
      request      :status_server
      request      :convert_server
      request      :compact_server
      request      :snapshot_server
      request      :snapshot_switch_server
      request      :snapshot_delete_server
      request      :snapshot_mount_server
      request      :snapshot_umount_server
      request      :snapshot_list_server
      request      :quotaon_server
      request      :quotaoff_server
      request      :quotainit_server
      request      :exec_server
      request      :exec2_server
      request      :runscript_server
      request      :suspend_server
      request      :resume_server
      request      :set_server

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :servers => [],
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @openvz_connect_command = options[:openvz_connect_command]
        end

        def data
          self.class.data[@openvz_connect_command]
        end

        def reset_data
          self.class.data.delete(@openvz_connect_command)
        end
      end

      class Real
        def initialize(options={})
          @openvz_connect_command = options[:openvz_connect_command]
        end

        def reload
          #@connection.reset
        end

        def expand_commands(commands, params, args)
          # For all params unless the ctid
          # pass it to the command
          params.keys.each do |k|
            if (params[k]) && (k.to_s != 'ctid')

              if params[k].is_a?(Array)
                # For arrays we pass the params and key multiple times
                params[k].each do |p|
                  commands << "--#{k}"
                  commands << "\"#{p}\""
                end
              else
                commands << "--#{k}"
                # For booleans only pass the options
                # We put the values of params between doublequotes
                commands << "\"#{params[k]}\"" unless !!params[k] == params[k]
              end

            end
          end

          # These commands will be passed directly
          args.each do |a|
            commands << a
          end

          # Delete empty commands
          commands.delete("")

          # Now build the full command
          full_command = "#{commands.join(' ')}"

          # If we have a connect command , expand it
          if @openvz_connect_command.nil?
            prefixed_command = "#{full_command}"
          else
            prefixed_command = @openvz_connect_command.sub('@command@',"#{full_command}")
          end
          return prefixed_command
        end

        def vzctl(command, params,args = [])
          commands = [ 'vzctl', command, params['ctid'], params[:ctid] ]
          prefixed_command = expand_commands(commands, params, args)

          result = `#{prefixed_command}`
          exitcode = $?.to_i

          # Tofix - we use backticks to get the exitcode
          # But backticks output stderr
          arg_commands = [ 'exec', 'exec2', 'runscript' ]
          if (arg_commands.include?(command))
            return { :output => result , :exitcode => exitcode }
          else
            raise Fog::Errors::Error.new result unless exitcode == 0
            return result
          end
        end

        def vzlist(params,args = [])
          commands = [ 'vzlist', '-a', '-j' , params['ctid'], params[:ctid] ]
          prefixed_command = expand_commands(commands, params, args)

          # We do some wier stuff here:
          # - a simple backtick doesn't capture stderr
          # - popen4 would solve it but would require another external gem dependency
          # - popen3 doesn't capture exitcode (on ruby 1.8) but is a standard call
          # - so we resort to checking the stderr instead
          require 'open3'
          result = ""
          error = ""
          puts prefixed_command
          Open3.popen3("#{prefixed_command}") { |i,o,e,t|
            result = result + o.read
            error = error + e.read
          }

          if (error.length != 0)
            if(error.include?("not found"))
              return []
            else
              raise Fog::Errors::Error.new error
            end
          else
            return Fog::JSON.decode(result)
          end
        end
      end
    end
  end
end
