# This file was auto-generated by lib/generators/tasks/generate.rb
#
require_relative 'endpoint/api'
require_relative 'endpoint/apps'
require_relative 'endpoint/auth'
require_relative 'endpoint/bots'
require_relative 'endpoint/channels'
require_relative 'endpoint/chat'
require_relative 'endpoint/conversations'
require_relative 'endpoint/dialog'
require_relative 'endpoint/discovery'
require_relative 'endpoint/dnd'
require_relative 'endpoint/emoji'
require_relative 'endpoint/files'
require_relative 'endpoint/groups'
require_relative 'endpoint/idpgroups'
require_relative 'endpoint/im'
require_relative 'endpoint/migration'
require_relative 'endpoint/mpim'
require_relative 'endpoint/oauth'
require_relative 'endpoint/pins'
require_relative 'endpoint/presence'
require_relative 'endpoint/reactions'
require_relative 'endpoint/reminders'
require_relative 'endpoint/search'
require_relative 'endpoint/stars'
require_relative 'endpoint/team'
require_relative 'endpoint/usergroups'
require_relative 'endpoint/users'

module Slack
  module Endpoint
    include Api
    include Apps
    include Auth
    include Bots
    include Channels
    include Chat
    include Conversations
    include Dialog
    include Discovery
    include Dnd
    include Emoji
    include Files
    include Groups
    include Idpgroups
    include Im
    include Migration
    include Mpim
    include Oauth
    include Pins
    include Presence
    include Reactions
    include Reminders
    include Search
    include Stars
    include Team
    include Usergroups
    include Users
  end
end