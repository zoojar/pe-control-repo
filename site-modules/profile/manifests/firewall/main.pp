# main firewall profile
class profile::firewall::main {
  Firewall {
    before  => Class['profile::firewall::post'],
    require => Class['profile::firewall::pre'], 
  }
  class { 'firewall': }
}
