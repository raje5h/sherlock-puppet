Facter.add(:newsherlockversion) do
  setcode 'dpkg -l | grep fk-w3-sherlock | awk \'{print $3}\''
end
