class haproxy {
  
    exec { "install-ha-proxy":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-haproxy -t wheezy-backports",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 300,
    }
}
