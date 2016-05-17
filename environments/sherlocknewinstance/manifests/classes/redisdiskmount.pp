class redisdiskmount {
  
  exec { "disk-mount":
      command => "/sbin/mkfs.ext4 /dev/vdb && echo \"/dev/vdb /var/lib/fk-3p-redis ext4 rw,noatime,nodiratime 0 0\" >>/etc/fstab && (cd /var/lib/;mkdir fk-3p-redis) && mount /dev/vdb /var/lib/fk-3p-redis",
      path => [ "/bin/", "/usr/bin" ],
    }
}