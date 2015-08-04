class deploy {

    $packageVersion = hiera('version')
    $currentRotationStatus = $::rotationstatus

    exec { "admin-status":
       command => "sudo fk-w3-sherlock-admin status",
       logoutput => true,
       path => "/usr/bin/",
    }
}