class sample4 {
    file {"/home/udit.jain/ex-dir-2":
	ensure => "directory",
    }
    
    exec {"apt-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }

    exec {"install-package":
        command => "sudo apt-get install fk-w3-sherlock=1.1433944764-01nm",
        path => "/usr/bin/",
	require => Exec['apt-update'],
    }
}
