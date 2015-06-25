class sample2 {
    $Version = "1.1434364148-01nm"
    $env = "9"

    file {"/home/udit.jain/ex-dir-2":
	ensure => "directory",
    }
    
    exec {"apt-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
    }
   
    exec {"infra-cli":
        command => "reposervice --host repo-svc-app-0001.nm.flipkart.com --port 8080 getenv --name sherlock-sample-env --appkey $env --version HEAD > /etc/apt/sources.list.d/sources1.list",
        path => "",
    }
 
    package { "fk-w3-sherlock":
        ensure => $Version,
	logoutput => true,
        requires => Exec[infra-cli],
    }
}
