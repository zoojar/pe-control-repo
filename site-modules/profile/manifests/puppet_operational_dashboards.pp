# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::puppet_operational_dashboards
# @param manage_influxdb
# @param influxdb_host
# @param influxdb_port
# @param initial_org
# @param initial_bucket
# @param influxdb_bucket_retention_rules
# @param influxdb_token 
# @param telegraf_token 
# @param telegraf_token_name               
# @param influxdb_token_file               
# @param manage_telegraf                   
# @param manage_telegraf_token             
# @param use_ssl                           
# @param use_system_store                  
# @param include_pe_metrics
# @param manage_system_board
#
class profile::puppet_operational_dashboards (
  Boolean $manage_influxdb                    = true,
  String $influxdb_host                       = $facts['networking']['fqdn'],
  Integer $influxdb_port                      = 8086,
  String $initial_org                         = 'puppetlabs',
  String $initial_bucket                      = 'puppet_data',
  Array $influxdb_bucket_retention_rules      = [{ 'type' => 'expire', 'everySeconds' => 7776000, 'shardGroupDurationSeconds' => 604800 }],

  Optional[Sensitive[String]] $influxdb_token = undef,
  Optional[Sensitive[String]] $telegraf_token = undef,
  String $telegraf_token_name                 = 'puppet telegraf token',
  String $influxdb_token_file                 = $facts['identity']['user'] ? {
    'root'  => '/root/.influxdb_token',
    default => "/home/${facts['identity']['user']}/.influxdb_token"
  },
  Boolean $manage_telegraf                    = true,
  Boolean $manage_telegraf_token              = true,
  Boolean $use_ssl                            = true,
  Boolean $use_system_store                   = false,
  # Check for PE by looking at the compiling server's module_groups setting
  Boolean $include_pe_metrics = $settings::module_groups ? {
    /pe_only/ => true,
    default   => false,
  },

  Boolean $manage_system_board = true,
) {
  if $manage_influxdb {
    class { 'influxdb':
      host             => $influxdb_host,
      port             => $influxdb_port,
      use_ssl          => $use_ssl,
      use_system_store => $use_system_store,
      initial_org      => $initial_org,
      token_file       => $influxdb_token_file,
    }

    influxdb_org { $initial_org:
      ensure           => present,
      use_ssl          => $use_ssl,
      use_system_store => $use_system_store,
      port             => $influxdb_port,
      token            => $influxdb_token,
      token_file       => $influxdb_token_file,
      require          => Class['influxdb'],
    }
    influxdb_bucket { $initial_bucket:
      ensure           => present,
      use_ssl          => $use_ssl,
      use_system_store => $use_system_store,
      port             => $influxdb_port,
      org              => $initial_org,
      token            => $influxdb_token,
      retention_rules  => $influxdb_bucket_retention_rules,
      token_file       => $influxdb_token_file,
      require          => [Class['influxdb'], Influxdb_org[$initial_org]],
    }

    Influxdb_auth {
      require => Class['influxdb'],
    }
  }

  if $manage_telegraf_token {
    # Create a token with permissions to read and write timeseries data
    # The influxdb::retrieve_token() function cannot find a token during the catalog compilation which creates it
    #   i.e. it takes two agent runs to become available
    influxdb_auth { $telegraf_token_name:
      ensure           => present,
      use_ssl          => $use_ssl,
      use_system_store => $use_system_store,
      port             => $influxdb_port,
      org              => $initial_org,
      token            => $influxdb_token,
      token_file       => $influxdb_token_file,
      permissions      => [
        {
          'action'   => 'read',
          'resource' => {
            'type'   => 'telegrafs',
          }
        },
        {
          'action'   => 'write',
          'resource' => {
            'type'   => 'telegrafs',
          }
        },
        {
          'action'   => 'read',
          'resource' => {
            'type'   => 'buckets',
          }
        },
        {
          'action'   => 'write',
          'resource' => {
            'type'   => 'buckets',
          }
        },
      ],
    }
  }

  if $manage_telegraf {
    include 'puppet_operational_dashboards::telegraf::agent'
  }
  class { 'puppet_operational_dashboards::profile::dashboards':
    grafana_port => 443,
  }
  file { '/etc/grafana/conf.d/auth_viewer.ini':
    ensure  => file,
    content => @(EOF)
      [auth.anonymous]
      enabled = true
      org_role = Viewer
      | EOF
    ,
    notify  => Service['grafana-server'],
  }
}
