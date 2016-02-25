class hudsonapplicationsetup {
  
    exec { "fk-w3-hudson":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-w3-hudson",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 3000,
    }
}
