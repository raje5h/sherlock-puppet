class deploy {

    $Version = "1.1434364148-01nm"
    $env = "9"

    file {"/etc/apt/apt.conf.d/99auth":
        owner => root,
        group => root,
        content => "APT::Get::AllowUnauthenticated yes;",
        mode => 644,
    }

    file {"/etc/apt/sources.list.d/source1.list":
        owner => root,
        group => root,
        content => "deb http://d42-a-0002.nm.flipkart.com:8080/repos/infra-cli/3 /",
        mode => 644,
        require => File["/etc/apt/apt.conf.d/99auth"],
    }
    
    exec {"apt-update-1":
        command => "sudo apt-get update",
        path => "/usr/bin/",
	require => File["/etc/apt/sources.list.d/source1.list"],
    }

    package { "infra-cli":
	ensure => installed,
        require => Exec[apt-update-1],
    }

    exec { "infra-cli-command":
    	command => "reposervice --host repo-svc-app-0001.nm.flipkart.com --port 8080 getenv --name sherlock-sample-env --appkey $env --version HEAD > /etc/apt/sources.list.d/source1.list",
	path => "/usr/bin/",
	require => Package[infra-cli],
    }
    
    exec {"apt-update-2":
        command => "sudo apt-get update",
        path => "/usr/bin/",
	require => Exec[infra-cli-command],
    }
    
    exec { "fk-w3-sherlock":
        command => "sudo apt-get -y --force-yes install fk-w3-sherlock=1.1434017924-01nm",
        path => "/usr/bin",
        logoutput => true,
	tries => 3,
        timeout => 50,
        require => Exec["apt-update-2"],
    }

    exec {"health-check-script":
         command => "sh /home/udit.jain/health-script.sh",
         path => [ "/bin/", "/usr/bin/" ],
         logoutput => true,
         require => Exec["fk-w3-sherlock"]
    }
}


