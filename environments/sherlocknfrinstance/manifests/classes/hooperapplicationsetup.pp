class hooperapplicationsetup {
  
    exec { "fk-sherlock-hooper":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-hooper",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 3000,
    }
}
