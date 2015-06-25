class deploy {

    $packageVersion = "1.1434364148-01nm"

    exec { "apt-update":
        command => "sudo apt-get update",
        logoutput => true,
        path => "/usr/bin/",
    }

    exec { "fk-w3-sherlock":
        command => "sudo apt-get -y --force-yes install fk-w3-sherlock=$packageVersion",
        path => "/usr/bin",
        logoutput => true,
	    tries => 2,
        timeout => 600,
        require => Exec["apt-update"],
    }

    file { "/home/udit.jain/health-check.sh":
            owner => root,
            group => root,
            content => "hostname=`hostname`
                        status=`curl -I "http://$hostname.nm.flipkart.com:25280/sherlock/intent?q=samsung" | grep "HTTP" | awk '{print $2}'`

                        if [ "$status" == "200" ]
                        then
                            echo "========curl command successfull========"
                            echo "status $status"
                            exit 0
                        else
                            echo "===========curl command failed=========="
                            echo "status = $status"
                            exit 2
                        fi",
            mode => 777,
    }

    exec { "health-check-script":
         command => "sh /home/udit.jain/health-script.sh",
         path => [ "/bin/", "/usr/bin/" ],
         logoutput => true,
         require => File["/home/udit.jain/health-check.sh"],
    }
}


