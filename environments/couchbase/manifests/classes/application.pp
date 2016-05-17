class application {

    $envVersion = "1"
    $envName = "sherlock-couchbase"
    $repo_svc_host = "repo-svc-app-0001.nm.flipkart.com"
    $repo_svc_port = "8080"
    $appkey = "12"

    $cosmosEnvVersion = "3"
    $cosmosEnvName = "sherlock-cosmos-env"

    $bucket = $::configbucket
    $cluster_fact = $::uniquefact
    $repos = "repos"

    exec { "update-sources-list":
        path => [ "/bin/", "/usr/bin" ],
        command => "echo `curl -s http://10.47.0.101/v1/buckets/sherlock-couchbase-l2  | grep -o '\"repos\":[^*\]*]' | awk '{ print "deb "$2" /"; print "deb "$4" /" }'` > /etc/apt/sources.list.d/couchbase.list",
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

    exec { "libssl0.9.8":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install libssl0.9.8",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 3000
    }

    exec { "couchbase-server":
        command => "sudo apt-get -y --allow-unauthenticated --force-yes install couchbase-server",
        path => "/usr/bin",
        logoutput => true,
        tries => 2,
        timeout => 3000,
        require => Exec["libssl0.9.8"],
    }
}
