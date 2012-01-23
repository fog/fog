module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/modify_db_instance'

        # modifies a database instance
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_ModifyDBInstance.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - name of the db instance to modify
        # * ApplyImmediately <~Boolean> - whether to apply the changes immediately or wait for the next maintenance window
        #                                     
        # * AllocatedStorage  <~Integer> Storage space, in GB
        # * AllowMajorVersionUpgrade <~Boolean> Must be set to true if EngineVersion specifies a different major version  
        # * AutoMinorVersionUpgrade <~Boolean> Indicates that minor version upgrades will be applied automatically to the DB Instance during the maintenance window 
        # * BackupRetentionPeriod  <~Integer> 0-8 The number of days to retain automated backups.
        # * DBInstanceClass <~String> The new compute and memory capacity of the DB Instanc 
        # * DBParameterGroupName <~String> The name of the DB Parameter Group to apply to this DB Instance  
        # * DBSecurityGroups <~Array> A list of DB Security Groups to authorize on this DB Instance 
        # * EngineVersion <~String> The version number of the database engine to upgrade to.
        # * MasterUserPassword  <~String> The new password for the DB Instance master user
        # * MultiAZ <~Boolean> Specifies if the DB Instance is a Multi-AZ deployment
        # * PreferredBackupWindow <~String> The daily time range during which automated backups are created if automated backups are enabled
        # * PreferredMaintenanceWindow <~String> The weekly time range (in UTC) during which system maintenance can occur, which may result in an outage
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def modify_db_instance(db_name, apply_immediately, options={})
          
          if security_groups = options.delete('DBSecurityGroups')
            options.merge!(Fog::AWS.indexed_param('DBSecurityGroups.member.%d', [*security_groups]))
          end
    
          request({
            'Action'  => 'ModifyDBInstance',
            'DBInstanceIdentifier' => db_name,
            'ApplyImmediately' => apply_immediately,
            :parser   => Fog::Parsers::AWS::RDS::ModifyDBInstance.new,
          }.merge(options))
        end

      end

      class Mock

        def modify_db_instance(db_name, apply_immediately, options={})
          response = Excon::Response.new
          if self.data[:servers][db_name]
            if self.data[:servers][db_name]["DBInstanceStatus"] != "available"
              raise Fog::AWS::RDS::NotFound.new("DBInstance #{db_name} not available for modification")
            else
              # TODO verify the params options
              # if apply_immediately is false, all the options go to pending_modified_values and then apply and clear after either 
              # a reboot or the maintainance window
              #if apply_immediately
              #  modified_server = server.merge(options)
              #else
              #  modified_server = server["PendingModifiedValues"].merge!(options) # it appends
              #end
              self.data[:servers][db_name]["PendingModifiedValues"].merge!(options) # it appends
              #self.data[:servers][db_name]["DBInstanceStatus"] = "modifying"
              response.status = 200
              response.body = {
                "ResponseMetadata"=>{ "RequestId"=> Fog::AWS::Mock.request_id },
                "ModifyDBInstanceResult" => { "DBInstance" => self.data[:servers][db_name] }
              }
              response
              
            end
          else
            raise Fog::AWS::RDS::NotFound.new("DBInstance #{db_name} not found")
          end
        end

      end
    end
  end
end
