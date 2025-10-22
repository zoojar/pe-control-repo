# An example role
class role::example {
  include profile::example
  $testdata = lookup('puppet_operational_dashboards::profile::dashboards::grafana_port', { 'default_value' => 'default value' })
  notify { "grafana_port is ${testdata}": }
}
