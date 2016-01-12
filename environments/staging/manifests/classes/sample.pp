class sample {
     
    $bucket = $::configbucket
    
    exec { "update-cluster-name":
        command => "sudo echo `curl -s \"http://10.47.0.101/v1/buckets/$bucket\" | jq .'keys.\"conman-cluster-name\"'`
        > /etc/default/cluster-name", 
        path => "/usr/bin/",
    }
}
