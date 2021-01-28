class profile::base (
  String $ntp_server
){

  #the base profile should include component modules that will be on all nodes
  include profile::motd

}
