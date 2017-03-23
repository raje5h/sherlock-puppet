class solrapplicationsetup {
  
    exec { "fk-sherlock-solr":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-solr",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 3000,
    }
}
