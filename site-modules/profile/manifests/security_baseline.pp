# security baseline profile
class profile::security_baseline (
  Array[String] $time_servers = ['tick.usno.navy.mil', 'tock.usno.navy.mil'],
  String        $profile_type = 'server' ,
  Array[String] $remote_access_allowed_users = ['vagrant'],
) {
  class { '::secure_linux_cis':
    time_servers  => $time_servers,
    profile_type  => $profile_type,
    allow_users   => $remote_access_allowed_users,
  } 
}
