class sample {
     
    $bucket = $::configbucket
    $cluster_fact = $::uniquefact
    $conman_cluster_name = "{conman-cluster-name}${cluster_fact}"
    
    exec { "update-cluster-name":
        command => "echo `curl -s \"http://10.47.0.101/v1/buckets/$bucket\" | jq  --arg cluster $conman_cluster_name  .'keys[$cluster]'` | sudo tee --append /etc/default/cluster-name", 
        path => [ "/bin/", "/usr/bin" ],
    }
}
