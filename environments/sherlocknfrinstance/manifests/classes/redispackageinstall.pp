class redispackageinstall {
    
    $envVersion = "HEAD"
    $envName = "fk-3p-redis-sherlock"
    
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"
    
    $bucket = $::configbucket
    $cluster_fact = $::uniquefact
    $redis_bucket_name = "redis-bucket-name.${cluster_fact}"
    
    
    exec { "infra-cli-command":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion > /etc/apt/sources.list.d/redis.list",
        path => "/usr/bin/",
    }
    
    exec { "apt-get-update-redis":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["infra-cli-command"],
    } 
    
    exec { "redis-install":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-3p-redis-2.8.x",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 3000,
        require => Exec["apt-get-update-redis"],
    }
    
    exec {"redis-update-config":
        command => "sudo /etc/init.d/fk-3p-redis update-confd-prefix server `curl -s \"http://10.47.0.101/v1/buckets/$bucket\" | grep -o '\"$redis_bucket_name\":[^,]*' | cut -d '\"' -f4`",
        path => [ "/bin/", "/usr/bin" ],
        logoutput => true,
        tries => 2,
        timeout => 3000,
        require => Exec["redis-install"], 
    }
    
    exec { "start-redis-server":
        command => "sleep 60 && sudo /etc/init.d/fk-3p-redis start server",
        path => [ "/bin/", "/usr/bin" ],
        logoutput => true,
        tries => 2,
        timeout => 3000,
        require => Exec["redis-update-config"],
    }  
}