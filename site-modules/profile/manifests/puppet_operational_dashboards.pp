# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::puppet_operational_dashboards
# @param grafana_config_file The path to the Grafana configuration file
class profile::puppet_operational_dashboards (
  String $grafana_config_file = '/etc/grafana/grafana.ini',
) {
  class { 'puppet_operational_dashboards':
    template_format => 'yaml',
  }
  file_capability { '/usr/sbin/grafana-server':
    capability => 'cap_net_bind_service=+ep',
  }
  Ini_setting {
    notify  => Service['grafana-server'],
  }
  ini_setting { 'auth.anonymous-enabled':
    path    => $grafana_config_file,
    section => 'auth.anonymous',
    setting => 'enabled',
    value   => true,
  }
  ini_setting { 'auth.anonymous-org_role':
    path    => $grafana_config_file,
    section => 'auth.anonymous',
    setting => 'org_role',
    value   => 'Viewer',
  }
  ini_setting { 'auth.basic-enabled':
    path    => $grafana_config_file,
    section => 'auth.basic',
    setting => 'enabled',
    value   => false,
  }
  ini_setting { 'auth-disable_login_form':
    path    => $grafana_config_file,
    section => 'auth',
    setting => 'disable_login_form',
    value   => true,
  }
}
