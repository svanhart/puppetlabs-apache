require 'spec_helper'

describe 'apache::fastcgi::server', :type => :define do
  let :pre_condition do
    'include apache'
  end
  let :title do
    'www'
  end
  describe 'os-dependent items' do
    context "on RedHat based systems" do
      let :default_facts do
        {
          :osfamily               => 'RedHat',
          :operatingsystemrelease => '6',
          :concat_basedir         => '/dne',
        }
      end
      let :facts do default_facts end
      it { should contain_class("apache") }
      it { should contain_class("apache::mod::fastcgi") }
      it { should contain_file("fastcgi-pool-#{title}.conf").with(
        :ensure => 'present',
        :path => "/etc/httpd/conf.d/fastcgi-pool-#{title}.conf"
      ) }
    end
    context "on Debian based systems" do
      let :default_facts do
        {
          :osfamily               => 'Debian',
          :operatingsystemrelease => '6',
          :concat_basedir         => '/dne',
        }
      end
      let :facts do default_facts end
      it { should contain_class("apache") }
      it { should contain_class("apache::mod::fastcgi") }
      it { should contain_file("fastcgi-pool-#{title}.conf").with(
        :ensure => 'present',
        :path   => "/etc/apache2/conf.d/fastcgi-pool-#{title}.conf"
      ) }
    end
    context "on FreeBSD systems" do
      let :default_facts do
        {
          :osfamily               => 'FreeBSD',
          :operatingsystemrelease => '9',
          :concat_basedir         => '/dne',
        }
      end
      let :facts do default_facts end
      it { should contain_class("apache") }
      it { should contain_class("apache::mod::fastcgi") }
      it { should contain_file("fastcgi-pool-#{title}.conf").with(
        :ensure => 'present',
        :path   => "/usr/local/etc/apache22/Includes/fastcgi-pool-#{title}.conf"
      ) }
    end
  end
  describe 'os-independent items' do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end
    describe ".conf content" do
      let :params do
        {
          :host      => '127.0.0.1:9001',
          :timeout   => 30,
          :flush     => true,
          :faux_path => '/var/www/php-www.fcgi',
          :alias     => '/php-www.fcgi',
          :file_type => 'application/x-httpd-php'
        }
      end
      let :expected do
'FastCGIExternalServer /var/www/php-www.fcgi -idle-timeout 30 -flush -host 127.0.0.1:9001
Alias /php-www.fcgi /var/www/php-www.fcgi
Action application/x-httpd-php /php-www.fcgi
'
      end
      it do
        should contain_file("fastcgi-pool-www.conf").with_content(expected)
      end
    end
  end
end
