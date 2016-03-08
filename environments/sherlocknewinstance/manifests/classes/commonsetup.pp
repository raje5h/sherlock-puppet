class commonsetup {
    
    exec { "infra-cli-source":
        command => "sudo echo 'deb http://10.47.2.22:80/repos/infra-cli/3 /' > /etc/apt/sources.list.d/infra-cli-svc.list",
        path => "/usr/bin/",
    }
    
    exec { "apt-get-update-infra":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["infra-cli-source"],
    }
    
    exec { "infra-cli-install":
        command => "sudo apt-get install --yes --allow-unauthenticated infra-cli",
        path => "/usr/bin/",
        require => Exec["apt-get-update-infra"],
    }
    
    exec { "install-screen":
        command => "sudo apt-get install --yes --allow-unauthenticated screen",
        path => "/usr/bin/",
        require => Exec["infra-cli-install"],
    }
    
    exec { "update-jenkins-user-package":
        command => "echo 'deb http://10.47.2.22:80/repos/fk-w3-user/8 /' | sudo tee --append /etc/apt/sources.list.d/jenkins.list",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["install-screen"]
    }
    
    exec { "apt-update-jenkins":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["update-jenkins-user-package"]
    }
    
    exec { "install-jenkins-users":
        command => "sudo apt-get install --yes --allow-unauthenticated fk-w3-user",
        path => "/usr/bin/",
        require => Exec["apt-update-jenkins"]
    }
    
    exec { "add-sudo-jenkins":
        command => "echo 'fk-w3-jenkins ALL=(ALL) NOPASSWD: ALL' | sudo tee --append /etc/sudoers.d/jenkins",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["install-jenkins-users"]
    }
    
    exec { "adding-host-1":
        command => "echo '10.65.30.211  pf-config-publish-alt.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["add-sudo-jenkins"],
    }
    
    exec { "adding-host-2":
        command => "echo '10.65.38.79   pf-config-manage.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-1"],
    }
    
    exec { "adding-host-3":
        command => "echo '10.65.100.54   ops-statsd.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-2"],
    }
    
    exec { "adding-host-4":
        command => "echo '10.32.241.213   sherlock-app-slave-db.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-3"],
    }
    
    exec { "adding-host-5":
        command => "echo '10.32.241.213    sherlock-slave-db.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-4"],
    }
    
    exec { "adding-host-6":
        command => "echo '10.84.35.1    pf-config-publish.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-5"],
    }
    
    exec { "tcp-setting-1":
        command => "echo 'net.core.somaxconn=1024' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-6"],
    }
    
    exec { "tcp-setting-2":
        command => "echo 'net.ipv4.ip_local_port_range=15000    61000' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["tcp-setting-1"],
    }
    
    exec { "tcp-setting-3":
        command => "echo 'net.ipv4.tcp_fin_timeout=30' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["tcp-setting-2"],
    } 
    
    exec { "tcp-1":
        command => "echo 'net.core.wmem_max=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-setting-3"],
    }
    
    exec { "tcp-2":
        command => "echo 'net.ipv4.tcp_rmem= 10240 87380 12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-1"],
    }
    
    exec { "tcp-3":
        command => "echo 'net.ipv4.tcp_wmem= 10240 87380 12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-2"],
    }
    
    exec { "tcp-4":
        command => "echo 'net.core.netdev_max_backlog = 3000'  | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-3"],
    }
    
    exec { "tcp-5":
        command => "echo 'net.core.rmem_max=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-4"],
    }
    exec { "tcp-6":
        command => "echo 'net.core.wmem_default=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-5"],
    }
    exec { "tcp-7":
        command => "echo 'net.core.rmem_default=12582912' | sudo tee --append /etc/sysctl.d/sherlock.conf",
        path => [ "/bin/", "/usr/bin" ],
        require => Exec["tcp-6"],
    }
    
    exec { "tcp-apply":
        command => "sudo sysctl --system",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["tcp-7"],
    }   
    
    exec { "disk-mount":
      command => "/sbin/mkfs.ext4 /dev/vdb && echo \"/dev/vdb /var/lib/fk-w3-sherlock ext4 rw,noatime,nodiratime 0 0\" >>/etc/fstab && (cd /var/lib/;mkdir fk-w3-sherlock) && mount /dev/vdb /var/lib/fk-w3-sherlock",
      path => [ "/bin/", "/usr/bin" ],
      require => Exec["tcp-apply"],
    }
}
