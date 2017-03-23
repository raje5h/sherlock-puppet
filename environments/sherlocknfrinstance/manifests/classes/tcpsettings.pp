class tcpsettings {
  
  exec { "tcp-setting-1":
        command => "echo 'net.core.somaxconn=512' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ] ,
    }
    
    exec { "tcp-setting-2":
        command => "echo 'net.ipv4.ip_local_port_range=32768    61000' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["tcp-setting-1"],
    }
    
    exec { "tcp-setting-3":
        command => "echo 'net.ipv4.tcp_fin_timeout=10' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["tcp-setting-2"],
    } 
    
    exec { "tcp-setting-4":
        command => "echo 'net.core.wmem_max=16777216' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-3"],
    }
    
    exec { "tcp-setting-5":
        command => "echo 'net.ipv4.tcp_rmem= 4096 87380 16777216' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-4"],
    }
    
    exec { "tcp-setting-6":
        command => "echo 'net.ipv4.tcp_wmem= 4096 16384 16777216' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-5"],
    }
    
    exec { "tcp-setting-7":
        command => "echo 'net.core.netdev_max_backlog = 4096'  | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-6"],
    }
    
    exec { "tcp-setting-8":
        command => "echo 'net.core.rmem_max=16777216' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-7"],
    }
    
    exec { "tcp-setting-9":
        command => "echo 'net.core.wmem_default=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-8"],
    }
    exec { "tcp-setting-10":
        command => "echo 'net.core.rmem_default=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-9"],
    }
    
    exec { "tcp-setting-11":
        command => "echo 'net.ipv4.tcp_slow_start_after_idle=0' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-10"],
    }
    
    exec { "tcp-setting-12":
        command => "echo 'net.ipv4.tcp_tw_reuse=1' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-11"],
    }
    
    exec { "tcp-setting-13":
        command => "echo 'net.ipv4.tcp_max_syn_backlog=2048' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-12"],
    }
    
    exec { "tcp-setting-14":
        command => "sudo sysctl vm.overcommit_memory=1",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-13"],
    }
    
    exec { "tcp-apply":
        command => "sudo sysctl --system",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["tcp-setting-14"],
    }
}