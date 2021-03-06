# Class: curator
#
# Parameters: none
#
# Actions:
#
# Sample Usage:
#
class curator (
  $modules = $curator::params::modules,
  $path    = $curator::params::path,
) inherits curator::params {
  
  package { 'librarian-puppet':
    ensure   => 'present',
    provider => 'gem',
  }

  file { "$path/Puppetfile":
    ensure  => file,
    content => inline_template('forge "https://forgeapi.puppetlabs.com"
<% @modules.each do |val| -%>
mod "<%= val %>"
<% end -%>'),
  }

  exec { '/usr/bin/librarian-puppet install':
    cwd         => "$path",
    subscribe   => File["$path/Puppetfile"],
    refreshonly => true,
    require     => Package['librarian-puppet'],
  }
}