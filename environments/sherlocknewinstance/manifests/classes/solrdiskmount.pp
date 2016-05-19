class solrdiskmount {
  exec { "disk-mount":
    command => "/sbin/mkfs.ext4 /dev/vdb && echo \"/dev/vdb /var/lib/fk-sherlock-solr ext4 rw,noatime,nodiratime 0 0\" >>/etc/fstab && (cd /var/lib/;mkdir fk-sherlock-solr) && mount /dev/vdb /var/lib/fk-sherlock-solr",
    path    => ["/bin/", "/usr/bin"],
  }

}