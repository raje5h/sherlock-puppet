node /^sherlock-(app-cloud|test-env)-redis/ {
        include commoninfrasetup
        include tcpsettings
        include redispackageinstall
        include redisdiskmount
        include cosmosredis
        
        Class['commoninfrasetup'] -> Class['tcpsettings'] -> Class['redisdiskmount'] -> Class['redispackageinstall'] -> Class['cosmosredis']
}