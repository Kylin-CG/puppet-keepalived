### cloud lvs
$public_interface         = 'eth0'
$lvs_master_hostname      = puppetserver
$lvs_interface            = $public_interface
$lvs_virtual_ip           = '172.20.120.222'
$cloud_controller_nums    = 1
$cloud_controller_1       = '172.20.120.201'
$cloud_controller_2       = undef
$cloud_controller_3       = undef
$cloud_controller_4       = undef

node /cloud_lvs/ {
  
  if ($::hostname == $lvs_master_hostname) {
    $state = "MASTER"
  } else {
    $state = "BACKUP"
  }

  class {
    'keepalived':
    email               => 'root@localhost'
  }

  keepalived::vrrp_instance {
    "42":
      kind              => $state,
      interface         => $lvs_interface,
      virtual_router_id => 42,
      virtual_addresses => ["$lvs_virtual_ip"],
  }

  keepalived::virtual_server {
    'fwmark':
      port     => 1,
      lb_kind  => 'DR',
      protocol => 'TCP',
      ip       => 'fwmark',
  }

  case $cloud_controller_nums {
    "1": {
      keepalived::real_server {
        "$cloud_controller_1":
          virtual_server_ip   => 'fwmark',
          ip                  => "$cloud_controller_1",
          ports               => ['8776','9191','9292','5000','35357','11211','8773','8774','8775','9696','80'],
          check_type          => 'TCP',
          virtual_server_name => 'fwmark',
          virtual_server_port => 1,
      }
    } 
    "2": {
      keepalived::real_server {
        "$cloud_controller_1":
          virtual_server_ip   => 'fwmark',
          ip                  => "$cloud_controller_1",
          ports               => ['8776','9191','9292','5000','35357','11211','8773','8774','8775','9696','80'],
          check_type          => 'TCP',
          virtual_server_name => 'fwmark',
          virtual_server_port => 1,
      }
    
      keepalived::real_server {
        "$cloud_controller_2":
          virtual_server_ip   => 'fwmark',
          ip                  => "$cloud_controller_2",
          ports               => ['8776','9191','9292','5000','35357','11211','8773','8774','8775','9696','80'],
          check_type          => 'TCP',
          virtual_server_name => 'fwmark',
          virtual_server_port => 1,
      }
    }
    "4": {
      keepalived::real_server {
        "$cloud_controller_1":
          virtual_server_ip   => 'fwmark',
          ip                  => "$cloud_controller_1",
          ports               => ['8776','9191','9292','5000','35357','11211','8773','8774','8775','9696','80'],
          check_type          => 'TCP',
          virtual_server_name => 'fwmark',
          virtual_server_port => 1,
      }
    
      keepalived::real_server {
        "$cloud_controller_2":
          virtual_server_ip   => 'fwmark',
          ip                  => "$cloud_controller_2",
          ports               => ['8776','9191','9292','5000','35357','11211','8773','8774','8775','9696','80'],
          check_type          => 'TCP',
          virtual_server_name => 'fwmark',
          virtual_server_port => 1,
      }
      keepalived::real_server {
        "$cloud_controller_3":
          virtual_server_ip   => 'fwmark',
          ip                  => "$cloud_controller_3",
          ports               => ['8776','9191','9292','5000','35357','11211','8773','8774','8775','9696','80'],
          check_type          => 'TCP',
          virtual_server_name => 'fwmark',
          virtual_server_port => 1,
      }
    
      keepalived::real_server {
        "$cloud_controller_4":
          virtual_server_ip   => 'fwmark',
          ip                  => "$cloud_controller_4",
          ports               => ['8776','9191','9292','5000','35357','11211','8773','8774','8775','9696','80'],
          check_type          => 'TCP',
          virtual_server_name => 'fwmark',
          virtual_server_port => 1,
      }

    }
  }

  class { 'keepalived::iptables_rule':
    virtual_ip           => $lvs_virtual_ip,
  }

}
