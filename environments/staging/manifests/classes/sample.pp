class sample {
     
    $bucket = $::configbucket
    
    exec { "update-cluster-name":
        command => "echo `curl -s \"http://10.47.0.101/v1/buckets/$bucket\" | jq .'keys.\"conman-cluster-name\"' | tr -d '\"'` | sudo tee --append /etc/default/cluster-name", 
        path => [ "/bin/", "/usr/bin" ],
    }
}
