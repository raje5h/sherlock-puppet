Facter.add(:solrversion) do
  setcode 'dpkg -l | grep fk-sherlock-solr | awk \'{print $3}\''
end