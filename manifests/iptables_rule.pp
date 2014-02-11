class keepalived::iptables_rule (
  $virtual_ip = '127.0.0.1',
  $ports      = '8776,9191,9292,5000,35357,11211,8773,8774,8775,9696,80',
) {

  file { "/opt/iptables.sh":
    mode    => 0755,
    content => template('keepalived/iptables_rule.erb'),
  }

  exec { "exec_iptables":
    command => "bash /opt/iptables.sh",
    path    => '/sbin:/bin:/usr/sbin:/usr/bin',
    logoutput => true,
  }
}

