module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/create_db_instance'

        # create a db instance
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
        # ==== Parameters
        # * DBInstanceIdentifier <~String> - name of the db instance to modify
        #
        # * AllocatedStorage  <~Integer> Storage space, in GB
        # * AutoMinorVersionUpgrade <~Boolean> Indicates that minor version upgrades will be applied automatically to the DB Instance during the maintenance window
        # * AvailabilityZone <~String> The availability zone to create the instance in
        # * BackupRetentionPeriod  <~Integer> 0-8 The number of days to retain automated backups.
        # * DBInstanceClass <~String> The new compute and memory capacity of the DB Instance
        # * DBName <~String> The name of the database to create when the DB Instance is created
        # * DBParameterGroupName <~String> The name of the DB Parameter Group to apply to this DB Instance
        # * DBSecurityGroups <~Array> A list of DB Security Groups to authorize on this DB Instance
        # * Engine <~String> The name of the database engine to be used for this instance.
        # * EngineVersion <~String> The version number of the database engine to use.
        # * MasterUsername <~String> The db master user
        # * MasterUserPassword  <~String> The new password for the DB Instance master user
        # * MultiAZ <~Boolean> Specifies if the DB Instance is a Multi-AZ deployment
        # * Port <~Integer> The port number on which the database accepts connections.
        # * PreferredBackupWindow <~String> The daily time range during which automated backups are created if automated backups are enabled
        # * PreferredMaintenanceWindow <~String> The weekly time range (in UTC) during which system maintenance can occur, which may result in an outage
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def create_db_instance(db_name, options={})

          if security_groups = options.delete('DBSecurityGroups')
            options.merge!(Fog::AWS.indexed_param('DBSecurityGroups.member.%d', [*security_groups]))
          end

          request({
            'Action'  => 'CreateDBInstance',
            'DBInstanceIdentifier' => db_name,
            :parser   => Fog::Parsers::AWS::RDS::CreateDBInstance.new,
          }.merge(options))
        end

      end

      class Mock

        def create_db_instance(db_name, options={})
          response = Excon::Response.new
          if self.data[:servers] and self.data[:servers][db_name]
            # I don't know how to raise an exception that contains the excon data
            #response.status = 400
            #response.body = {
            #  'Code' => 'DBInstanceAlreadyExists',
            #  'Message' => "DB Instance already exists"
            #}
            #return response
            raise Fog::AWS::RDS::IdentifierTaken.new("DBInstanceAlreadyExists #{response.body.to_s}")
          end

          # These are the required parameters according to the API
          required_params = %w{AllocatedStorage DBInstanceClass Engine MasterUserPassword MasterUsername }
          required_params.each do |key|
            unless options.has_key?(key) and options[key] and !options[key].to_s.empty?
              #response.status = 400
              #response.body = {
              #  'Code' => 'MissingParameter',
              #  'Message' => "The request must contain the parameter #{key}"
              #}
              #return response
              raise Fog::AWS::RDS::NotFound.new("The request must contain the parameter #{key}")
            end
          end

          data =
              {
                 "DBInstanceIdentifier"=> db_name,
                 "DBName" => options["DBName"],
                 "InstanceCreateTime" => nil,
                 "AutoMinorVersionUpgrade"=>true,
                 "Endpoint"=>{},
                 "ReadReplicaDBInstanceIdentifiers"=>['bla'],
                 "PreferredMaintenanceWindow"=>"mon:04:30-mon:05:00",
                 "Engine"=> options["Engine"],
                 "EngineVersion"=> options["EngineVersion"] || "5.1.57",
                 "PendingModifiedValues"=>{"MasterUserPassword"=>"****"}, # This clears when is available
                 "MultiAZ"=>false,
                 "MasterUsername"=> options["MasterUsername"],
                 "DBInstanceClass"=> options["DBInstanceClass"],
                 "DBInstanceStatus"=>"creating",
                 "BackupRetentionPeriod"=> options["BackupRetentionPeriod"] || 1,
                 "AllocatedStorage"=> options["AllocatedStorage"],
                 "DBParameterGroups"=> # I think groups should be in the self.data method
                          [{"DBParameterGroupName"=>"default.mysql5.1",
                            "ParameterApplyStatus"=>"in-sync"}],
                 "DBSecurityGroups"=>
                          [{"Status"=>"active", 
                            "DBSecurityGroupName"=>"default"}],
                 "LicenseModel"=>"general-public-license",
                 "PreferredBackupWindow"=>"08:00-08:30",
#                 "ReadReplicaSourceDBInstanceIdentifier" => nil,
#                 "LatestRestorableTime" => nil,
                 "AvailabilityZone" => options["AvailabilityZone"]
             }


          self.data[:servers][db_name] = data
          response.body = {
            "ResponseMetadata"=>{ "RequestId"=> Fog::AWS::Mock.request_id },
            "CreateDBInstanceResult"=> {"DBInstance"=> data}
          }
          response.status = 200
          # This values aren't showed at creating time but at available time
          self.data[:servers][db_name]["InstanceCreateTime"] = Time.now
          response
        end

      end
    end
  end
end
