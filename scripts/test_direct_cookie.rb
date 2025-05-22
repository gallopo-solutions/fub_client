#!/usr/bin/env ruby
require 'bundler/setup'
require 'fub_client'
require 'dotenv'
require 'pry'
Dotenv.load

# Set debug mode
ENV['DEBUG'] = 'true'

puts "-------------------------------------------"
puts "Testing SharedInbox API with Direct Cookie"
puts "-------------------------------------------"

# Step 1: Initialize CookieClient with 'raw' cookie format
subdomain = ENV['FUB_SUBDOMAIN'] || 'jdouglasproperties'
puts "💡 Set subdomain to: #{subdomain}"

# Initialize client with raw cookie format
client = FubClient::CookieClient.new(nil, 'raw')
client.subdomain = subdomain

# Set cookie directly instead of fetching from gist
# You can set this in your .env file or paste directly here
raw_cookie = ENV['FUB_COOKIE'] || '_gcl_au=1.1.1071326943.1745264289; _vwo_uuid_v2=DD21C4BF1F11B49B50474EE782A3DAFD0|68fd4e278b8921bb84f6f614d2e72528; [truncated for brevity]'

puts "🍪 Setting raw cookie..."
client.cookies = raw_cookie
puts "✅ Cookie set (#{raw_cookie.length} characters)"

# Add a breakpoint for debugging
puts "\n🔍 Debug point - inspect client state"
binding.pry if ENV['DEBUG_PRY']

# Step 2: Get all shared inboxes
puts "\n📬 Fetching all shared inboxes..."
begin
  inboxes = FubClient::SharedInbox.all_inboxes
  puts "Found #{inboxes.count} shared inboxes"
  
  inboxes.each do |inbox|
    puts "  - Inbox ID: #{inbox.id}, Name: #{inbox.name}"
  end
rescue => e
  puts "❌ Error fetching shared inboxes: #{e.message}"
  puts e.backtrace.join("\n") if ENV['DEBUG']
  puts "Debugging error:"
  binding.pry if ENV['DEBUG_PRY']
end

# Step 3: Get a specific shared inbox
puts "\n📬 Fetching first shared inbox..."
begin
  if inboxes && inboxes.first
    inbox_id = inboxes.first.id
    inbox = FubClient::SharedInbox.get_inbox(inbox_id)
    
    if inbox
      puts "✅ Found inbox: #{inbox.name} (ID: #{inbox.id})"
      
      # Get settings
      puts "\n⚙️ Fetching settings for inbox #{inbox.id}..."
      settings = inbox.settings
      puts "Settings: #{settings.inspect}"
      
      # Get conversations
      puts "\n💬 Fetching conversations for inbox #{inbox.id}..."
      conversations = inbox.conversations(5, 0)
      puts "Found #{conversations.count} conversations"
      
      # Get messages
      puts "\n📨 Fetching messages for inbox #{inbox.id}..."
      messages = inbox.messages(5, 0)
      puts "Found #{messages.count} messages"
    else
      puts "❌ Inbox with ID #{inbox_id} not found"
    end
  else
    puts "❌ No inboxes found to test with"
  end
rescue => e
  puts "❌ Error fetching shared inbox: #{e.message}"
  puts e.backtrace.join("\n") if ENV['DEBUG']
  puts "Debugging error:"
  binding.pry if ENV['DEBUG_PRY']
end

puts "\n-------------------------------------------"
puts "Test completed!"
puts "-------------------------------------------"
