# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::puppet_operational_dashboards
class profile::puppet_operational_dashboards {
  include puppet_operational_dashboards
  #class { 'puppet_operational_dashboards::profile::dashboards':
  #  grafana_port => 443,
  #}
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
