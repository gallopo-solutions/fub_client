# Libs
require 'base64'
require 'singleton'
require 'logger'
require 'active_support'
require 'active_support/all'
require 'active_support/core_ext/hash/keys'
require 'faraday'
require 'facets/string/snakecase'
require 'multi_json'
# require 'fub_client/compatibility'
require 'her'

# App
require "fub_client/version"
require "fub_client/client"
require "fub_client/middleware"
require "fub_client/resource"
# App Models
require "fub_client/event"
require "fub_client/person"
require "fub_client/note"
require "fub_client/call"
require "fub_client/user"
require "fub_client/smart_list"
require "fub_client/email_template"
require "fub_client/action_plan"
require "fub_client/em_event"
require "fub_client/custom_field"

module FubClient
  def self.root
    File.expand_path '../..', __FILE__
  end  
end
