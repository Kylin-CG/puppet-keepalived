class keepalived(
  $email,
  $smtp_server = '127.0.0.1'
) {

  package {
    "keepalived":
      ensure => installed;
  }

  service {
    "keepalived":
      ensure     => running,
      require    => Package["keepalived"],
      hasrestart => true,
      status     => 'pgrep keepalived',
      subscribe  => File["/etc/keepalived/concat/top"];
  }

  file {
    '/etc/keepalived/concat':
      ensure  => directory,
      require => Package['keepalived'];
  }

  exec {
    'concat_keepalived.conf':
      command     => '/bin/cat /etc/keepalived/concat/* > /etc/keepalived/keepalived.conf',
      refreshonly => true,
      notify      => Service['keepalived'];
  }

  concat {
    '/etc/keepalived/concat/top':
      warn    => true,
      require => Package['keepalived'],
      notify  => Exec['concat_keepalived.conf'];
  }

  concat::fragment {
    'keepalived.global_defs':
      content => template("keepalived/global_defs.erb"),
      order   => 01,
      target  => '/etc/keepalived/concat/top';
  }

}
