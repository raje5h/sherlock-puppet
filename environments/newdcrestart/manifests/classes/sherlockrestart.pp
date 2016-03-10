  class sherlockrestart {

    exec { "restart":
            command => "sudo /etc/init.d/fk-w3-sherlock restart",
            logoutput => true,
            timeout => 1800,
            path => "/usr/bin/",
        }    
}