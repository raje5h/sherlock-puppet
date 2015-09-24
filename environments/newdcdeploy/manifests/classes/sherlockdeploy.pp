class sherlockdeploy {

    $envVersion = "HEAD"
    $envName = "sherlock-sample-env"
    $host = "repo-svc-app-0001.nm.flipkart.com"
    $port = "8080"
    $appkey = "12"

    exec { "infra-cli-command":
    	command => "reposervice --host $host --port $port getenv --name $envName --appkey $appkey --version $envVersion > /etc/apt/sources.list.d/sherlock.list",
	    path => "/usr/bin/",
    }
    
    exec { "apt-get-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
	    require => Exec["infra-cli-command"],
    }
    
    exec { "fk-w3-sherlock":
        command => "sudo apt-get -y --force-yes install fk-w3-sherlock",
        path => "/usr/bin",
        logoutput => true,
	    tries => 2,
        timeout => 600,
        require => Exec["apt-get-update"],
    }

    file { "/home/vishal.goel/health-script.sh":
        owner => root,
        group => root,
        content => template("common/health-script"),
        mode => 777,
        require => Exec["fk-w3-sherlock"],
    }

    #exec { "health-check-script":
    #     command => "sh /home/vishal.goel/health-script.sh",
    #     path => [ "/bin/", "/usr/bin/" ],
    #     logoutput => true,
    #     require => Exec["/home/vishal.goel/health-script.sh"]
    #}
}


