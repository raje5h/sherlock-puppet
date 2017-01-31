

node /^sherlock-app-base.*aggregator/ {
        include sherlockclouddeploy
        include tcpsettings
        include etchostrefresh

        Class['etchostrefresh'] -> Class['tcpsettings'] -> Class['sherlockclouddeploy']
}

node /^sherlock-app-base.*solr-only/ {
        include sherlocksolrdeploy
        include tcpsettings
        include etchostrefresh

        Class['etchostrefresh'] -> Class['tcpsettings'] -> Class['sherlocksolrdeploy']
}

node /^sherlock-app/ {
        include sherlockdeploy
}
