class sample3 {
    file {"/home/udit.jain/ex-dir-2":
	ensure => "directory",
    }
    
    exec {"apt-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }
}
