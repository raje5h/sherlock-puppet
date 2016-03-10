  class sherlockrestart {

    exec { "restart":
            command => "sudo /etc/init.d/fk-w3-sherlock restart",
            logoutput => false,
            timeout => 1800,
            path => "/usr/bin/",
        }    
}