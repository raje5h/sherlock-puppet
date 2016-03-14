class redispackageinstall {
    
    $envVersion = "HEAD"
    $envName = "fk-3p-redis-sherlock"
    
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"
    
    $bucket = $::configbucket
    $cluster_fact = $::uniquefact
    
    exec { "infra-cli-command":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion > /etc/apt/sources.list.d/redis.list",
        path => "/usr/bin/",
    }
    
    /*exec { "export-redis-bucket-step1":
        command => 'echo \'Defaults env_keep += "CONFIG_BUCKET"\' | sudo tee --append /etc/sudoers',
        path => [ "/bin/", "/usr/bin", "/sbin" ],
        require => Exec["infra-cli-command"],
    }*/
    
    exec { "export-redis-bucket-step1":
        command => 'echo \'Defaults env_keep += "CONFIG_BUCKET"\' | sudo tee --append /etc/sudoers',
        path => [ "/bin/", "/usr/bin", "/sbin" ],
        require => Exec["infra-cli-command"],
    }
    
    exec { "export-redis-bucket":
        command => 'echo \'CONFIG_BUCKET=redis-sherlock\' | sudo tee --append /etc/default/redis',
        path => [ "/bin/", "/usr/bin", "/sbin" ],
        require => Exec["export-redis-bucket-step1"],
    }
    
    exec { "export-redis-bucket-2":
        command => 'true && . /etc/default/redis',
        provider => shell,
        path => [ "/bin/", "/usr/bin", "/sbin" ],
        require => Exec["export-redis-bucket"],
    }
    
    exec { "apt-get-update-redis":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["export-redis-bucket-2"],
    } 
    
    exec { "redis-install":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-3p-redis-2.8.x",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 3000,
        require => Exec["apt-get-update-redis"],
    }
    
    exec { "start-redis-server":
        command => "sudo /etc/init.d/fk-3p-redis start server",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 3000,
        require => Exec["redis-install"],
    }  
}