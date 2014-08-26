class node_console_env {
  augeas { 'node_console_env':
    changes => ['set /files/etc/puppetlabs/puppet/puppet.conf/master/node_terminus node_console_env'],
  }
}
