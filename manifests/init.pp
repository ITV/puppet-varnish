# == Class: varnish
#
# Configure Varnish proxy cache
#
# === Parameters
#
# [*addrepo*]
#   Whether to add the official Varnish repos
# [*secret*]
#   Varnish secret (used by varnishadm etc)
# [*vcl_conf*]
#   Location of Varnish config file template
# [*listen*]
#   IP address for HTTP to listen on
# [*listen_port*]
#   Port to listen on for HTTP requests
# [*admin_listen*]
#   IP address for admin requests - defaults to 127.0.0.1
# [*admin_port*]
#   Port for Varnish admin to listen on
# [*min_threads*]
#   Varnish minimum thread pool size
# [*max_threads*]
#   Varnish maximum thread pool size
# [*thread_timeout*]
#   Thread timeout
# [*storage_type*]
#   Whether to use malloc (RAM only) or file storage for cache
# [*storage_size*]
#   Size of cache
# [*varnish_version*]
#   Major Varnish version to use - 3.0 or 4.0
# [*vcl_reload*]
#   Script to use to load new Varnish config
# [*package_ensure*]
#   Ensure specific package version for Varnish, eg 3.0.5-1.el6
# [*runtime_params*]
#   Hash of runtime parameters
#
class varnish (
  $addrepo         = $varnish::params::addrepo,
  $secret          = 'notsosecret',
  $secret_file     = $varnish::params::secret_file,
  $vcl_conf        = $varnish::params::vcl_conf,
  $listen          = $varnish::params::listen,
  $listen_port     = $varnish::params::listen_port,
  $admin_listen    = $varnish::params::admin_listen,
  $admin_port      = $varnish::params::admin_port,
  $min_threads     = $varnish::params::min_threads,
  $max_threads     = $varnish::params::max_threads,
  $thread_timeout  = $varnish::params::thread_timeout,
  $storage_type    = $varnish::params::storage_type,
  $storage_file    = $varnish::params::storage_file,
  $storage_size    = $varnish::params::storage_size,
  $varnish_version = $varnish::params::varnish_version,
  $vcl_reload      = $varnish::params::vcl_reload,
  $package_ensure  = $varnish::params::package_ensure,
  $runtime_params  = {}
) inherits varnish::params {

  validate_bool($addrepo)
  validate_string($secret)
  validate_absolute_path($secret_file)
  unless is_integer($listen_port) { fail('listen_port invalid') }
  unless is_integer($admin_port) { fail('admin_port invalid') }
  unless is_integer($min_threads) { fail('min_threads invalid') }
  unless is_integer($max_threads) { fail('max_threads invalid') }
  validate_absolute_path($storage_file)
  validate_hash($runtime_params)
  validate_re($varnish_version, '^[3-4]\.0')
  validate_re($storage_type, '^(malloc|file)$')

  if ($addrepo) {

    class { $varnish::params::repoclass:
      before => Class['varnish::install'],
    }
  }

  class { 'varnish::secret':
    require => Class['varnish::install'],
  }

  class { 'varnish::install': } ->
  class { 'varnish::config': } ~>
  class { 'varnish::service': } ->
  Class['varnish']
}
