require 'rubygems'
require 'sinatra-index'
require 'sinatra_auth_github'
require 'rack'
require 'dotenv'
require 'safe_yaml'
require_relative 'jekyll-auth/version'
require_relative 'jekyll-auth/auth-site'
require_relative 'jekyll-auth/jekyll-site'
Dotenv.load

class JekyllAuth
  def self.site
    Rack::Builder.new do
      use JekyllAuth::AuthSite
      run JekyllAuth::JekyllSite
    end
  end
  
  def self.config_file
    File.join(Dir.pwd, "_config.yml")
  end

  def self.config
    @config ||= begin
      config = YAML.safe_load_file(config_file)
      config["jekyll_auth"]
    rescue
      {}
    end
  end

  def self.whitelist
    whitelist = JekyllAuth::config["whitelist"]
    Regexp.new(whitelist.join("|")) unless whitelist.nil?
  end

  def self.ssl?
    !!JekyllAuth::config["ssl"]
  end
end
