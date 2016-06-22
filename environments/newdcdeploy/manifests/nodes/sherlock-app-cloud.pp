
node /^sherlock-(internal-app|app)-cloud-(internal|sherlock)-aggregator/ {
        include sherlockcoredeploy
        include tcpsettings
        include etchostrefresh
        
         Class['etchostrefresh'] -> Class['tcpsettings'] -> Class['sherlockcoredeploy']
}

node /^sherlock-(internal-app|app)-cloud/ {
        include sherlocksolrdeploy
        include tcpsettings
        include etchostrefresh
        
        Class['etchostrefresh'] -> Class['tcpsettings'] -> Class['sherlocksolrdeploy']
}

node /^sherlock-test-env-(preprod|perf).*(aggregator)/ {
        include sherlockcoredeploy
        include tcpsettings
        include etchostrefresh
        
         Class['etchostrefresh'] -> Class['tcpsettings'] -> Class['sherlockcoredeploy']
}


node /^sherlock-test-env-(preprod|perf)/ {
        include sherlocksolrdeploy
        include tcpsettings
        include etchostrefresh
        Class['etchostrefresh'] -> Class['tcpsettings'] -> Class['sherlocksolrdeploy']
}