group{ 'puppet': ensure  => present }

node default {


  class{'docker':
    tcp_bind  => 'tcp://127.0.0.1:4243'
  }

  docker::image { 'ubuntu':
    tag => 'precise'
  }

  class{'nginx':
    manage_repo => false
  }

  file { '/etc/ssl/nginx':
    ensure => directory,
    owner  => $nginx::params::nx_daemon_user,
    mode   => '750',
  } ->

  file { '/root/.rnd':
    ensure => present,
    content=> $random,
    mode   => '600',
    owner  => 'root',
  } ->

  openssl::certificate::x509 { $fqdn:
    ensure       => present,
    country      => 'US',
    organization => 'Big',
    unit         => 'The Punisher Unit',
    state        => 'Pomorskie',
    locality     => 'Gdansk',
    commonname   => $fqdn,
    email        => 'lukasz.budnik@gmail.com',
    days         => 3456,
    base_dir     => '/etc/ssl/nginx',
    force        => true,
    owner        => $nginx::params::nx_daemon_user,
  } ->

  nginx::resource::upstream { "${fqdn}-upstream":
    ensure  => present,
    members => ["localhost:${port}"],
  } ->

  nginx::resource::vhost { $fqdn:
    ensure      => present,
    listen_port => 443,
    ssl         => true,
    ssl_cert    => "/etc/ssl/nginx/${fqdn}.crt",
    ssl_key     => "/etc/ssl/nginx/${fqdn}.key",
    proxy       => "http://${fqdn}-upstream",
  }
}
