
node /^sherlock-app-cloud-solr-only/ {
        include sherlocksolrdeploy
        include tcpsettings
        
         Class['tcpsettings'] -> Class['sherlocksolrdeploy']
}

node /^sherlock-(internal-app|app)-cloud/ {
        include sherlockclouddeploy
}

node /^sherlock-test-env-(preprod|perf)/ {
        include sherlockclouddeploy
}