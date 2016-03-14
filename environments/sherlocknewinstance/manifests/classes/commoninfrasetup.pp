class commoninfrasetup {
  
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
}