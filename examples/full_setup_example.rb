# How to run:
# docker run -it -v /Users/diegodurs/Code/rightsup/rightsup.github.io:/app ruby:2.3.7-alpine3.7 /bin/sh

# CONSTANTS
##########################
EMAIL = 'test-user@rightsup.com'
PASSWORD = 'password'
PARTNER_SLUG = 'believe'


# Per Client Data
##########################

client_name = 'RightsUp - Performance Test'
client_country = 'FR'

# Helpers
##########################

require 'uri'
require 'net/http'
require 'json'

def https_generic(url, body = {}, token = '', http_method_class)
  uri = URI(url)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  req = http_method_class.new(uri.path,
    'Content-Type' => 'application/json',
    'AUTHORIZATION' => token
  )
  req.body = body.to_json if body
  res = https.request(req)

  if res.code.to_i >= 200 && res.code.to_i < 300
    JSON.parse(res.body)
  else
    raise StandardError, "HTTP API ERROR: #{res.code}: #{res.body}"
  end
end

def https_get(url, token = '')
  https_generic(url, nil, token, Net::HTTP::Get)
end

def https_post(url, body, token = '')
  https_generic(url, body, token, Net::HTTP::Post)
end

def https_put(url, body, token = '')
  https_generic(url, body, token, Net::HTTP::Put)
end


# 1) Login
# =======================

credentials = https_post(
  "https://staging-api.rightsup.com/accounts/v1/auth", {
    "username" => EMAIL,
    "password" => PASSWORD
  }
)
@jwt_token = credentials['credentials']['id_token']

# 2) Setup Client
# =======================

client_data = https_post(
  'https://staging-api.rightsup.com/accounts/v1/clients/producers', {
    "client": {
      "company_name": client_name,
      "country_code": client_country
    }
  },
  @jwt_token
)

@client_slug = client_data['client']['slug']
@client_slug = 'RU1061'


# Add to partner
##########################

https_put("https://staging-api.rightsup.com/accounts/v1/partners/#{PARTNER_SLUG}/add_client/#{@client_slug}", {}, @jwt_token)

# Set the "owned labels"
##########################

https_put("https://staging-api.rightsup.com/accounts/v1/clients/#{@client_slug}/owned_labels", {
    "owned_label_names": ["Choke Industry"]
  }, @jwt_token
)

# Skip creating contract, leaving this to an humanoid ...
##########################

# Verify the infos so far:
##########################

client_data = https_get("https://staging-api.rightsup.com/accounts/v1/clients/#{@client_slug}", @jwt_token)
puts client_data['owned_label_names']
puts client_data['partner_slug']


# 3) Import release
# ========================

release_tracks = YAML.load(File.read('/app/examples/lilly_wood_and_the_prick.yaml'))

imported_release = https_post("https://staging-api.rightsup.com/music_import/v1/import_flat_release/inline", {
  "client_slug" => @client_slug,
  "labels" => [
    {
      "external_ids" => [],
      "label_catalog_number" => release_tracks['release']['label_catalog_number'],
      "label_name" => release_tracks['release']['label_name'],
      "label_code" => nil
    }
  ],
  "release" => {
    "release_credited_artists" => [],
    "external_ids" => [],
    "release_bar_code" => release_tracks['release']['release_bar_code'],
    "release_c_date" => release_tracks['release']['release_c_date'],
    "release_c_year" => release_tracks['release']['release_c_year'],
    "release_display_artist" => release_tracks['release']['release_display_artist'],
    "release_distributors" => (release_tracks['release']['release_distributors'] || []),
    "release_first_release_country_code" => release_tracks['release']['release_first_release_country_code'],
    "release_formats" => release_tracks['release']['release_formats'],
    "release_title" => release_tracks['release']['release_title'],
    "release_types" => release_tracks['release']['release_types'].split(', ')
  },
  "tracks" => release_tracks['tracks'].map do |track|
    {
      "recording_p_owner_country_code" => track['recording_p_owner_country_code'],
      "recording_p_owner_name" => track['recording_p_owner_name'],
      "recording_library_type" => track['recording_library_type'],
      "recording_display_artist" => track['recording_display_artist'],
      "recording_display_title" => track['recording_display_title'],
      "recording_duration_mm_ss" => track['recording_duration_mm_ss'],
      "recording_genres" => track['recording_genres'],
      "recording_is_classical" => track['recording_is_classical'],
      "recording_is_video" => track['recording_is_video'],
      "recording_isrcs" => track['recording_isrcs'],
      "recording_p_country_code" => track['recording_p_country_code'],
      "recording_p_year" => track['recording_p_year'],
      "recording_publisher" => track['recording_publisher'],
      "recording_title" => track['recording_title'],
      "recording_track_isrc" => track['recording_track_isrc'],
      "recording_track_position" => track['recording_track_position'],
      "recording_version" => track['recording_version'],
      "recording_credited_artists" => [],
      "recording_extra_artists" => [],
      "external_ids" => []
    }
  end
},
@jwt_token)

@recording_ids = imported_release['recordings'].map {|t| t['id']}


# 4) Claim release
# ========================

@recording_ids.each do |recording_id|
  https_post('https://staging-api.rightsup.com/producer_claims/v1/by_recordings/create', {
      "client_slug" => @client_slug,
      "owner_type" => "original_copyright_owner",
      "owner_name" => client_name,
      "first_owner_name" => client_name,
      "first_owner_country" => client_country,
      "i_am_the_first_owner" => true,
      "date_range" => {
        "start_date" => nil,
        "end_date" => nil
      },
      "percentage" => "100.0",
      "territory_coverage" => {
        "type" => "world_except",
        "country_codes" => []
      },
      "recording_ids" => [recording_id]
    }, @jwt_token)
end