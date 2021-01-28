class profile::base (
  String $ntp_server
  String $motd_content
){

  #the base profile should include component modules that will be on all nodes
  class { 'motd':
    content => $motd_content,
  }

}
