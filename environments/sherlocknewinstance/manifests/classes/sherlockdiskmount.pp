class sherlockdiskmount {
  exec { "disk-mount":
    command => "/sbin/mkfs.ext4 /dev/vdb && echo \"/dev/vdb /var/lib/fk-w3-sherlock ext4 rw,noatime,nodiratime 0 0\" >>/etc/fstab && (cd /var/lib/;mkdir fk-w3-sherlock) && mount /dev/vdb /var/lib/fk-w3-sherlock",
    path    => ["/bin/", "/usr/bin"],
  }
}