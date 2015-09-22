class sample {
    
    exec { "apt-update-1":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }

    exec { "apt-update-2":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }

    exec { "restart":
            command => "sudo /etc/init.d/fk-w3-hudson restart",
            logoutput => true,
            path => "/usr/bin/",
        }

    exec { "bir":
            command => "sudo fk-w3-hudson-admin bir",
            logoutput => true,
            path => "/usr/bin/",
            tries => 2,
            require => Exec["restart"],
        }
}
