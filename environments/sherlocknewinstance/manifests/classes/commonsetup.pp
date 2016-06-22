class commonsetup {
    
    $dpIp = $::db_entry
        
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
        command => "echo '$dpIp   sherlock-app-slave-db.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-3"],
    }
    
    exec { "adding-host-5":
        command => "echo '$dpIp    sherlock-slave-db.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-4"],
    }
    
    exec { "adding-host-6":
        command => "echo '10.84.35.1    pf-config-publish.nm.flipkart.com' | sudo tee --append /etc/hosts",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec["adding-host-5"],
    }   
}
