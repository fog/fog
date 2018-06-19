# -------------------------------------------------------------------------- #
# Copyright 2002-2014, OpenNebula Project (OpenNebula.org), C12G Labs        #
#                                                                            #
# Licensed under the Apache License, Version 2.0 (the "License"); you may    #
# not use this file except in compliance with the License. You may obtain    #
# a copy of the License at                                                   #
#                                                                            #
# http://www.apache.org/licenses/LICENSE-2.0                                 #
#                                                                            #
# Unless required by applicable law or agreed to in writing, software        #
# distributed under the License is distributed on an "AS IS" BASIS,          #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
# See the License for the specific language governing permissions and        #
# limitations under the License.                                             #
#--------------------------------------------------------------------------- #

#
# This class provides support for launching and stopping a websockify proxy
#

require 'rubygems'
require 'json'
begin
  require "opennebula"
rescue LoadError
  raise Fog::Errors::LoadError, "To use OpenNebula provider, you must load 'opennebula' gem"
end


#if !ONE_LOCATION
    NOVNC_LOCK_FILE = "/var/lock/.novnc.lock"
#else
#    NOVNC_LOCK_FILE= ONE_LOCATION + "/var/.novnc.lock"
#end

TOKEN_EXPIRE_SECONDS = 4

VNC_STATES = [
        #0,  #LCM_INIT
        #1,  #PROLOG
        #2,  #BOOT
        "3",  #RUNNING
        "4",  #MIGRATE
        #5,  #SAVE_STOP
        #6,  #SAVE_SUSPEND
        #7,  #SAVE_MIGRATE
        #8,  #PROLOG_MIGRATE
        #9,  #PROLOG_RESUME
        #10, #EPILOG_STOP
        #11, #EPILOG
        "12", #SHUTDOWN
        "13", #CANCEL
        #14, #FAILURE
        #15, #CLEANUP_RESUBMIT
        "16", #UNKNOWN
        "17", #HOTPLUG
        "18", #SHUTDOWN_POWEROFF
        #19, #BOOT_UNKNOWN
        #20, #BOOT_POWEROFF
        #21, #BOOT_SUSPENDED
        #22, #BOOT_STOPPED
        #23, #CLEANUP_DELETE
        "24", #HOTPLUG_SNAPSHOT
        "25", #HOTPLUG_NIC
        "26", #HOTPLUG_SAVEAS
        "27", #HOTPLUG_SAVEAS_POWEROFF
        "28", #HOTPLUG_SAVEAS_SUSPENDED
        "29"  #SHUTDOWN_UNDEPLOY
        #30, #EPILOG_UNDEPLOY
        #31, #PROLOG_UNDEPLOY
        #32  #BOOT_UNDEPLOY
]

VAR_LOCATION = Dir.pwd + "/extras/noVNC" 
SHARE_LOCATION = Dir.pwd + "/extras/noVNC"
class OpenNebulaVNC

    attr_reader :proxy_port

    def initialize(config, logger, options = {})
        opts={ :json_errors => true,
               :token_folder_name => 'sunstone_vnc_tokens'}.merge(options)

        @pipe = nil
        @token_folder = File.join(VAR_LOCATION, opts[:token_folder_name])
        @proxy_path   = File.join(SHARE_LOCATION, "websockify/websocketproxy.py")
        @proxy_port   = config[:vnc_proxy_port]

        @proxy_ipv6   = config[:vnc_proxy_ipv6]

        @wss = config[:vnc_proxy_support_wss]

        @lock_file = NOVNC_LOCK_FILE

        if (@wss == "yes") || (@wss == "only") || (@wss == true)
            @enable_wss = true
            @cert       = config[:vnc_proxy_cert]
            @key        = config[:vnc_proxy_key]
        else
            @enable_wss = false
        end
        @options = opts
        @logger = logger
    end

    def start
        if is_running?
            message="VNC server already running"
            STDERR.puts message
            @logger.info message
            return false
        end

        create_token_dir

        proxy_options = "--target-config=#{@token_folder} "

        if @enable_wss
            proxy_options << " --cert #{@cert}"
            proxy_options << " --key #{@key}" if @key && @key.size > 0
            proxy_options << " --ssl-only" if @wss == "only"
        end

        if @proxy_ipv6
            proxy_options << " -6"
        end

        cmd ="python #{@proxy_path} #{proxy_options} #{@proxy_port}"

        begin
            @logger.info { "Starting VNC proxy: #{cmd}" }
            pid=start_daemon(cmd, VNC_LOG)
        rescue Exception => e
            @logger.error e.message
            return false
        end

        File.open(@lock_file, "w") do |f|
            f.write(pid.to_s)
        end

        sleep 1

        if !is_running?
            message="Error starting VNC proxy"
            STDERR.puts message
            @logger.error message
            File.delete(@lock_file) if File.exist?(@lock_file)

            return false
        end

        STDOUT.puts "VNC proxy started"

        true
    end

    def proxy(vm_resource)
        # Check configurations and VM attributes
        #if !is_running?
        #    return error(400, "VNC Proxy is not running")
        #end

        if !VNC_STATES.include?(vm_resource['LCM_STATE'])
            return error(400,"Wrong state (#{vm_resource['LCM_STATE']}) to open a VNC session")
        end

        if vm_resource['TEMPLATE/GRAPHICS/TYPE'].nil? ||
           vm_resource['TEMPLATE/GRAPHICS/TYPE'].downcase != "vnc"
            return error(400,"VM has no VNC configured")
        end

        # Proxy data
        host     = vm_resource['HISTORY_RECORDS/HISTORY[last()]/HOSTNAME']
        vnc_port = vm_resource['TEMPLATE/GRAPHICS/PORT']
        vnc_pw = vm_resource['TEMPLATE/GRAPHICS/PASSWD']

        # Generate token random_str: host:port
        random_str = rand(36**20).to_s(36) #random string a-z0-9 length 20
        token = "#{random_str}: #{host}:#{vnc_port}"
        token_file = 'one-'+vm_resource['ID']

        # Create token file
        
	begin
            f = File.open(File.join(@token_folder, token_file), 'w')
            f.write(token)
            f.close
        rescue Exception => e
#            @logger.error e.message
            return error(500, "Cannot create VNC proxy token")
        end

        info   = {
	    :proxy_port => "29876",
            :password => vnc_pw,
            :token => random_str,
            :vm_name => vm_resource['NAME']
        }

        return [200, info]
    end

    # Delete proxy token file
    def delete_token(filename)
        begin
            File.delete(File.join(@token_folder, filename))
        rescue => e
            @logger.error "Error deleting token file for VM #{vm_id}"
            @logger.error e.message
        end
    end

    def stop(force=false)
        pid=get_pid

        if pid
            @logger.info "Killing VNC proxy"

            signal=(force ? 'KILL' : 'TERM')
            Process.kill(signal ,pid)

            sleep 1

            begin
                Process.getpgid(pid)

                Process.kill('KILL', pid)
            rescue
            end

            if is_running?
                message="VNC server is still running"
                STDERR.puts message
                logger.error message
                return false
            end

            delete_token_dir
        else
            message="VNC server is not running"
            @logger.info message
            STDERR.puts message
        end
        true
    end

    def status
        if is_running?
            STDOUT.puts "VNC is running"
            true
        else
            STDOUT.puts "VNC is NOT running"
            false
        end
    end

    private

    def error(code, msg)
        if @options[:json_errors]
            return [code,OpenNebula::Error.new(msg).to_json]
        else
            return [code,msg]
        end
    end

    def create_token_dir
        delete_token_dir
        begin
            Dir.mkdir(@token_folder) if !File.exist?(@token_folder)
        rescue Exception => e
            @logger.error "Cannot create token folder"
            @logger.error e.message
        end
    end

    def delete_token_dir
        if File.exist?(@token_folder)
            begin
                Dir.glob("#{@token_folder}/*").each do |file|
                    File.delete(file)
                end
            rescue => e
                @logger.error "Error deleting token folder"
                @logger.error e.message
            end
        end
    end

    def is_running?
        if File.exist?(@lock_file)
            pid=File.read(@lock_file).strip

            if system("ps #{pid} 1> /dev/null")
                return pid.to_i
            end

            @logger.info "Deleting stale lock file"
            File.delete(@lock_file)
        end

        false
    end
    alias_method :get_pid, :is_running?

if RUBY_VERSION<'1.9'
    def spawn(*args)
        fork {
            command=args[0..-2]

            # Close stdin and point out and err to log file
            $stdin.close
            $stdout.reopen(VNC_LOG, "a")
            $stderr.reopen(VNC_LOG, "a")

            # Detach process from the parent
            Process.setsid

            exec(*command)
        }
    end
end

    def start_daemon(cmd, log)
        options={
            :pgroup => true,
            :in => :close,
            [:out, :err] => [log, "a"],
            :close_others => true }

        params=cmd.split(" ")+[options]
        pid=spawn( *params )

        Process.detach(pid)

        pid
    end
end

