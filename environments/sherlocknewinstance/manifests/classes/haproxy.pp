class application {
  
    exec { "install-ha-proxy":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-haproxy",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 300,
    }
}
