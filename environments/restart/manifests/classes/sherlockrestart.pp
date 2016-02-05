class sherlockrestart {

    $currentRotationStatus = $::rotationstatus

    exec { "restart":
            command => "sudo /etc/init.d/fk-w3-sherlock restart",
            logoutput => true,
            timeout => 1800,
            path => "/usr/bin/",
    }
    
    if $currentRotationStatus != "In rotation" {
        exec { "admin-bir":
            command => "sudo fk-w3-sherlock-admin bir",
            logoutput => true,
            path => "/usr/bin/",
            timeout => 3000,
            require => Exec["restart"],
        }    
    }
}