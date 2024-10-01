# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include role::compiler
class role::compiler {
  class { 'puppet_operational_dashboards::enterprise_infrastructure':
    template_format => 'yaml',
  }
}
