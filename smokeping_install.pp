# http://oss.oetiker.ch/smokeping/doc/smokeping_install.en.html

# requires:
# - rrdtool
#   - http://oss.oetiker.ch/rrdtool/
#   - https://github.com/oetiker/rrdtool-1.x
# - smokeping
#   - http://oss.oetiker.ch/smokeping/index.en.html
# - apache
# - fping
#   - http://www.fping.org/
# - echoping
# -

package { 'rrdtool':
  ensure => present,
}

package { 'smokeping':
  ensure => present,
}

package { 'fping':
  ensure => present,
}

file { '/usr/share/smokeping':
  ensure => directory,
  require => Package [ 'smokeping' ],
  recurse => true,
  owner => 'apache',
}

file { '/etc/smokeping/config':
  ensure => present,
  source => '/vagrant/smokeping/config',
  require => Package [ 'smokeping' ],
  mode    => 0644,
  notify  => Service [ 'smokeping', 'httpd' ],
}

service { 'smokeping':
  ensure  => running,
  enable  => true,
  require => File [ '/etc/smokeping/config' ],
}

# augtool print /files/etc/httpd/conf.d/smokeping.conf
#    "setm /Directory/*[self::directive=Require]/arg 'all granted'",
#    'setm /Directory/*[self::directive=Require]/arg "all granted"',
#    'setm /Directory/*[self::directive="Require"]/arg "all granted"',
#augeas { 'smokeping.conf':
#  context => '/files/etc/httpd/conf.d/smokeping.conf',
#  changes => [
#    'setm /Directory/*[self::directive="Require"]/arg "all granted"',
#             ],
#  require => Package [ 'smokeping' ],
#}
file { '/etc/httpd/conf.d/smokeping.conf':
  ensure  => present,
  source  => '/vagrant/smokeping/smokeping.conf',
  require => Package [ 'smokeping' ],
  mode    => 0644,
  owner   => 'root',
  group   => 'root',
  notify  => Service [ 'httpd' ],
}

package { 'httpd':
  ensure => present,
}

#               Augeas  [ 'smokeping.conf' ],
service { 'httpd':
  ensure => running,
  require => [
               Package [ 'httpd' ],
               Service [ 'smokeping' ],
               File [ '/etc/httpd/conf.d/smokeping.conf' ],
             ],
}

