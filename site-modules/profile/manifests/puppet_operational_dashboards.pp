# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::puppet_operational_dashboards
# @param grafana_config_file The path to the Grafana configuration file
# @param sysconfig A hash of sysconfig settings for Grafana
class profile::puppet_operational_dashboards (
  String $grafana_config_file = '/etc/grafana/grafana.ini',
  Hash $sysconfig = {
    'GF_SERVER_HTTP_PORT'        => '443',
    'GF_AUTH_ANONYMOUS_ENABLED'  => 'true',
    'GF_AUTH_BASIC_ENABLED'      => 'true',
    'GF_AUTH_ANONYMOUS_ORG_ROLE' => 'Viewer',
    'GF_AUTH_ANONYMOUS_ORG_NAME' => 'Main Org.',
  }
) {
  class { 'puppet_operational_dashboards':
    template_format => 'yaml',
  }
  file_capability { '/usr/sbin/grafana-server':
    capability => 'cap_net_bind_service=ep',
  }
  Ini_setting {
    notify  => Service['grafana-server'],
  }
  ini_setting { 'service-AmbientCapabilities':
    path    => '/etc/systemd/system/grafana-server.service.d/net_bind_service.conf',
    section => 'Service',
    setting => 'AmbientCapabilities',
    value   => 'CAP_NET_BIND_SERVICE',
  }
  ini_setting { 'service-CapabilityBoundingSet':
    path    => '/etc/systemd/system/grafana-server.service.d/net_bind_service.conf',
    section => 'Service',
    setting => 'CapabilityBoundingSet',
    value   => 'CAP_NET_BIND_SERVICE',
  }
  $sysconfig.each |$key, $value| {
    Ini_setting { "sysconfig-${key}=${value}":
      path    => '/etc/sysconfig/grafana-server',
      setting => $key,
      value   => $value,
      notify  => Class['grafana::service'],
    }
  }
}
