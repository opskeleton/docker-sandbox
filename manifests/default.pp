group{ 'puppet': ensure  => present }

node default {


  class{'docker':
    tcp_bind  => 'tcp://127.0.0.1:4243'
  }

  docker::image { 'ubuntu':
    tag => 'precise'
  }
}
