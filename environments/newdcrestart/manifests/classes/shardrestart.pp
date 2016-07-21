 class shardrestart {

    exec { "restart":
            command => "sudo /etc/init.d/fk-sherlock-solr restart",
            logoutput => false,
            timeout => 1800,
            path => "/usr/bin/",
        }    
}