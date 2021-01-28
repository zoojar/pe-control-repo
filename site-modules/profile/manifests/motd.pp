class profile::motd (
  String $content
){
  class { 'motd':
    content => $content,
  }
}
