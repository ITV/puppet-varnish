# Add the Varnish repo
class varnish::repo::el7 {
  yumrepo { 'varnish-cache':
    baseurl  => "https://packagecloud.io/varnishcache/varnish${::varnish::varnish_version}/el/7/\$basearch",
    descr    => 'Varnish-cache RPM repository',
    enabled  => 1,
    gpgcheck => 0
  }
}
