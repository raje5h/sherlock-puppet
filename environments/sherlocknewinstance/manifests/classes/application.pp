class application {
  
    $envVersion = "2"
    $envName = "sherlock-app-solr-env"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"
    
    $cosmosEnvVersion = "3"
    $cosmosEnvName = "sherlock-cosmos-env"
    
    $bucket = $::configbucket
    $cluster_fact = $::uniquefact
    $conman_cluster_name = "conman-cluster-name.${cluster_fact}"
    
    exec { "update-cluster-name":
        path => [ "/bin/", "/usr/bin" ],
        command => "echo `curl -s \"http://10.47.0.101/v1/buckets/$bucket\" | grep -o '\"$conman_cluster_name\":[^,]*' | cut -d '\"' -f4` | sudo tee --append /etc/default/cluster-name", 
    }
    
    exec { "infra-cli-command":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $envName --appkey $appkey --version $envVersion > /etc/apt/sources.list.d/sherlock.list",
        path => "/usr/bin/",
        require => Exec["update-cluster-name"],
    }
    
     exec { "cosmos-sources-list":
        command => "reposervice --host $repo_svc_host --port $repo_svc_port getenv --name $cosmosEnvName --appkey $appkey --version $cosmosEnvVersion > /etc/apt/sources.list.d/sherlock-cosmos.list",
        path => "/usr/bin/",
        require => Exec["infra-cli-command"],
    }
    exec { "apt-get-update":
        command => "sudo apt-get update",
        path => "/usr/bin/",
        require => Exec["cosmos-sources-list"],
    }
    
    exec { "install-ha-proxy":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-sherlock-haproxy",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 300,
        require => Exec["apt-get-update"],
    }
    
    exec { "fk-w3-sherlock":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install fk-w3-sherlock",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 3000,
        require => Exec["install-ha-proxy"],
    }
}
