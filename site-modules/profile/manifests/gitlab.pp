# gitlab
class profile::gitlab {
  class { 'gitlab':
    external_url => 'http://gitlab.local',
    gitlab_rails => {
      time_zone                 => 'UTC',
      gitlab_email_enabled      => false,
      gitlab_default_theme      => 4,
      gitlab_email_display_name => 'GitLab',
    },
    sidekiq      => {
      shutdown_timeout => 5
    }
  }
}
