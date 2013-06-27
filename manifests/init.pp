# == Class: sausage
#
# === Copyright
#
# Copyright (c) 2013 MetricWise, Inc. 
#
# === License:
#
# MIT
#
# === Parameters:
#
# [*sauce_username*]
#
# [*sauce_accesskey*]
#
class sausage(
    $docroot,
    $sauce_username,
    $sauce_accesskey
) {

# TODO package {} https://github.com/MetricWise/sausage-bun/blob/master/givememysausage.php#L125
# curl', 'dom', 'pcre', 'Phar', 'SPL', 'Reflection', 'openssl

# TODO package {} https://saucelabs.com/account?jumpstart=true (viewed from Linux browser while logged in)
# php-pear php5-curl php5-xdebug

    package {[ "php-pecl-xdebug", "php-phpunit-PHPUnit", "php-phpunit-PHPUnit-Selenium" ]:
        ensure => present,
        provider => yum,
        notify => Service["httpd"],
    }

    file { "/usr/local/bin/givememysausage.php":
        source => "puppet:///modules/sausage/sausage-bun/givememysausage.php",
    }

    exec { "Install Sauce":
        command => "php /usr/local/bin/givememysausage.php -m $sauce_username $sauce_accesskey",
        cwd => $docroot,
        require => File["/usr/local/bin/givememysausage.php"],
    }

    exec { "Configure Sauce":
        command => "$docroot/vendor/bin/sauce_config $sauce_username $sauce_accesskey",
        cwd => $docroot,
        require => Exec["Install Sauce"],
    }
}
