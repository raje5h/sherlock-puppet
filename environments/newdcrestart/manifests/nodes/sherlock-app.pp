
node /^sherlock-(internal-app|app)-cloud-(internal|sherlock)-aggregator/ {
        include sherlockrestart
}

node /^sherlock-(internal-app|app)-cloud/ {
        include shardrestart
}

node /^sherlock-app-base.*aggregator/ {
        include sherlockrestart
}

node /^sherlock-app-base.*solr-only/ {
        include shardrestart
}

node /^sherlock-test-env.*aggregator/ {
        include sherlockrestart
}


node /^sherlock-test-env.*solr-only/ {
        include shardrestart       
}