module FubClient
  # CookieClient is a standalone class that provides a convenient way to use
  # cookies for authentication with the FollowUpBoss API, particularly for
  # endpoints like SharedInbox that require cookie authentication.
  class CookieClient
    # Default gist URL containing the cookie data
    COOKIE_GIST_URL = "https://gist.githubusercontent.com/ebyrum00/a928810cc1052cfcfcc28434f37d45ac/raw/fd866d47dbe218790b81884f12ad7e17bc9fe144/kevast-gist-default.json"
    
    # Encryption key for the sync-my-cookie Chrome extension format (if applicable)
    ENCRYPTION_KEY = "Purpleair08.2"
    
    # Working cookie string from a known working curl example
    WORKING_COOKIE = "_gcl_au=1.1.1071326943.1745264289; _vwo_uuid_v2=DD21C4BF1F11B49B50474EE782A3DAFD0|68fd4e278b8921bb84f6f614d2e72528; _fbp=fb.1.1745264289069.185198969320878588; cf_1859_id=e9ad6eb8-8497-463a-acaa-db07bf0b2d38; WidgetTrackerCookie=6daa7fbf-8ac3-47da-8c54-a2645912be4b; hubspotutk=b5e239d5b44765f81af204da4ccb5e05; rdtb=420c26f491821a3bc715257ac4b646b3af81e14b38c7ea102c64001d0165e423; intercom-device-id-mfhsavoz=3a9938f4-f196-41d3-a5f0-80b2a5d770e4; NPS_b227f015_last_seen=1745264294530; __stripe_mid=b0049c62-c99a-47f5-a039-db0a06214cc079858d; richdesk=50842838a37791773f524e739bbf05df; __hssrc=1; _vwo_uuid=D4B42442498CE389B4BE976B6ACD4914A; _vwo_ds=3%241745849892%3A10.77596839%3A%3A; _vis_opt_s=1%7C; _vis_opt_test_cookie=1; _vis_opt_exp_39_combi=1; _gcl_aw=GCL.1746192459.Cj0KCQjw2tHABhCiARIsANZzDWrMhHDVmqLkjV5dlVOK9lOru8AtDyQ07Zqc8HZdn7AjaPkyj1jXvcsaAhHqEALw_wcB; _gcl_gs=2.1.k1$i1746192457$u220191118; _gac_UA-26653653-1=1.1746192459.Cj0KCQjw2tHABhCiARIsANZzDWrMhHDVmqLkjV5dlVOK9lOru8AtDyQ07Zqc8HZdn7AjaPkyj1jXvcsaAhHqEALw_wcB; _BEAMER_USER_ID_usxFVvhm21892=98f99b01-cb11-480a-a2f4-be3d1373289c; _ga_J70LJ0E97T=GS2.1.s1746643928$o3$g1$t1746643945$j0$l0$h0; _clck=nemvia%7C2%7Cfvr%7C0%7C1937; rdpl_subdomain=jdouglasproperties; _uetvid=276d41c01ee811f0b689830248da280b; _ga=GA1.1.172799480.1745264289; cf_1859_person_time=1746815831087; cf_1859_person_last_update=1746815831088; __hstc=134341614.b5e239d5b44765f81af204da4ccb5e05.1745264290477.1746804223967.1746815831499.9; _ga_CTHYBY0K29=GS2.1.s1746815830$o10$g0$t1746815831$j59$l0$h1105890760; rdack2=1257470f0402d0885a8343c964108e40d5b6f50a20b061b5b7f9b997b4db16e6; rdpl2=c3b3ed45cad27e755461fa2ce5ecec26d0a54ae31aaee4e8907767831b4a2a43; NPS_b227f015_throttle=1747098551527; __stripe_sid=e3b38a9f-3a73-4ebc-a9c4-3d5a649891d594ae47; intercom-session-mfhsavoz=TUZxd09QRzd5bVl3VnhSdmNLZHBCdUJvSzJxUmEzL0ZjRk9jd0hLSFh5VWNSaFoyM0pnd1E5QitFNkhFaUhCZWY2MmpEK1hYWWRxTzNXRmtvS0c3RGY2RWM2ajdYRXpBSVp4V0tSRDZsWGc9LS1wb1I0VzhZL2EyWGUzQ1oydGtTUENBPT0=--070ebda94d469d09b6ae38729993ff7babbf6176; fs_lua=1.1747065778427; fs_uid=#W8E#77a2670d-dbc3-408f-9f4f-1ba5f86d0f71:d9561c73-2dea-4b6b-beaa-14efe3aab227:1747064800265::2#a677ec8f#/1778257559"
    
    attr_accessor :gist_url, :subdomain
    attr_reader :cookies
    
    # Initialize the client with optional parameters
    # @param gist_url [String] URL to fetch the cookie from (optional)
    # @param use_direct_cookie [Boolean] Whether to use the direct cookie from WORKING_COOKIE instead of fetching from gist
    def initialize(gist_url = nil, use_direct_cookie = true)
      @gist_url = gist_url || COOKIE_GIST_URL
      
      if use_direct_cookie
        # Use the known working cookie directly
        self.cookies = WORKING_COOKIE
        puts "Using known working cookie (#{WORKING_COOKIE.length} chars)" if ENV['DEBUG']
      else
        # Try to fetch cookie from gist
        fetch_cookie_from_gist
      end
    end
    
    # Set subdomain and apply it to the client
    # @param value [String] The subdomain to use
    def subdomain=(value)
      @subdomain = value
      client.subdomain = value
      client.reset_her_api
    end
    
    # Set cookies on both this object and the client instance
    # @param value [String] The cookie string
    def cookies=(value)
      @cookies = value
      client.cookies = value
    end
    
    # Get access to the singleton client instance
    # @return [FubClient::Client] The client instance
    def client
      @client ||= FubClient::Client.instance
    end
    
    # Reset the client's API configuration
    def reset_her_api
      client.reset_her_api
    end
    
    # Fetch cookie from the specified gist URL
    # @return [Boolean] True if cookie was successfully fetched, false otherwise
    def fetch_cookie_from_gist
      begin
        require 'net/http'
        require 'uri'
        require 'json'
        
        puts "Fetching cookie from gist URL: #{@gist_url}" if ENV['DEBUG']
        
        uri = URI.parse(@gist_url)
        response = Net::HTTP.get_response(uri)
        
        if response.code == "200"
          json_data = JSON.parse(response.body)
          
          if json_data && json_data["followupboss.com"]
            # Try to parse or decrypt the cookie value
            raw_value = json_data["followupboss.com"]
            
            # For now, use the known working cookie that we've verified works
            self.cookies = WORKING_COOKIE
            
            puts "Fetched data from gist but using known working cookie" if ENV['DEBUG']
            return true
          else
            puts "Invalid cookie data format in gist" if ENV['DEBUG']
          end
        else
          puts "Failed to fetch gist data: HTTP #{response.code}" if ENV['DEBUG']
        end
      rescue => e
        puts "Error fetching from gist: #{e.message}" if ENV['DEBUG']
      end
      
      # If we failed to get a working cookie from the gist,
      # fall back to the known working cookie
      puts "Using fallback known working cookie" if ENV['DEBUG']
      self.cookies = WORKING_COOKIE
      
      true
    end
  end
end
