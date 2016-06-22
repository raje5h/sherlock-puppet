
node /^sherlock-(internal-app|app)-cloud-(internal|sherlock)-aggregator/ {
        include sherlockclouddeploy
        include tcpsettings
        include etchostrefresh
        
         Class['etchostrefresh'] -> Class['tcpsettings'] -> Class['sherlockclouddeploy']
}

node /^sherlock-(internal-app|app)-cloud/ {
        include sherlocksolrdeploy
        include tcpsettings
        include etchostrefresh
        
          Class['etchostrefresh'] -> Class['tcpsettings'] -> Class['sherlocksolrdeploy']
}

node /^sherlock-test-env-(preprod|perf).*(aggregator)/ {
        include sherlockclouddeploy
        include tcpsettings
        include etchostrefresh
        
         Class['etchostrefresh'] -> Class['tcpsettings'] -> Class['sherlockclouddeploy']
}


node /^sherlock-test-env-(preprod|perf).*solr-only/ {
        include sherlocksolrdeploy
        include tcpsettings
        include etchostrefresh
        Class['etchostrefresh'] -> Class['tcpsettings'] -> Class['sherlocksolrdeploy']
}