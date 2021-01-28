class profile::motd (
  String $content
){

  #the base profile should include component modules that will be on all nodes
  class { 'motd':
    content => $content,
  }

}
