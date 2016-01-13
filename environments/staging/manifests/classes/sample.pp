class sample {
     
    $bucket = $::configbucket
    $cluster_fact = $::uniquefact
    $conman_cluster_name = "conman-cluster-name${cluster_fact}"
    exec { "update-cluster-name":
        path => [ "/bin/", "/usr/bin" ],
        command => "echo `curl -s \"http://10.47.0.101/v1/buckets/$bucket\" | grep -o '\"$conman_cluster_name\":[^,]*' | cut -d '\"' -f4` | sudo tee --append /etc/default/cluster-name", 
    }
}
