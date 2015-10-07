class sample {
    
    exec { "apt-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }

    exec { "":
        command => "",
        path => [ "/bin/", "/usr/bin" ] ,
        require => Exec[""],
    }
}


