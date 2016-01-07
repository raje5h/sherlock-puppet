class commonsetup {

    exec { "infra-cli-source":
        command => "sudo echo 'deb http://10.47.2.22:80/repos/infra-cli/3 /' > /etc/apt/sources.list.d/infra-cli-svc.list",
        path => "/usr/bin/"
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
    
    exec { "adding-host-1":
        command => "echo '10.65.30.211  pf-config-publish-alt.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["infra-cli-install"],
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
    
    exec { "disk-mount":
      command => "/sbin/mkfs.ext4 /dev/vdb && echo \"/dev/vdb /var/lib/fk-w3-sherlock ext4 rw,noatime,nodiratime 0 0\" >>/etc/fstab && (cd /var/lib/;mkdir fk-w3-sherlock) && mount /dev/vdb /var/lib/fk-w3-sherlock",
      path => [ "/bin/", "/usr/bin" ],
      require => Exec["adding-host-5"],
      
    }
}
