node /^sherlock-(internal-app|app)-cloud/ {
        include sherlockclouddeploy
}

node /^sherlock-test-env-(preprod|perf)/ {
        include sherlockclouddeploy
}