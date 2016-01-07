class common {

   exec { "sudo-apt-get-update-2":
        command => "sudo apt-get update",
        logoutput => true,
        path => "/usr/bin/"
    }
}
