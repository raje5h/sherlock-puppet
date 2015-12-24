  class sherlockrestart {

    exec { "restart":
            command => "sudo /etc/init.d/fk-w3-sherlock restart",
            logoutput => true,
            path => "/usr/bin/",
        }

    exec { "bir":
            command => "sudo fk-w3-sherlock-admin bir",
            logoutput => true,
            path => "/usr/bin/",
            timeout => 3000,
            require => Exec["restart"],
        }
}