# security baseline profile
class profile::security_baseline (
  Array[String] $time_servers = ['0.uk.pool.ntp.org', '1.uk.pool.ntp.org'],
  String        $profile_type = 'server' ,
  Array[String] $remote_access_allowed_users = ['vagrant'],
  Array[String] $host_allow_rules, 
) {
  class { '::secure_linux_cis':
    time_servers     => $time_servers,
    profile_type     => $profile_type,
    allow_users      => $remote_access_allowed_users,
    host_allow_rules => $host_allow_rules,
  } 
}
