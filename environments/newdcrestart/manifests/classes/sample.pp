class sample {
    
    exec { "restart":
            command => "sudo /etc/init.d/fk-w3-hudson restart",
            logoutput => true,
            path => "/usr/bin/",
    }  
}
