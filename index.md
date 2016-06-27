---
layout: default
---

### [<span aria-hidden="true" class="octicon octicon-link"></span>](#overview)Welcome to Rights'Up API documentation.

All requests should be made against our Staging API endpoint: `http://www.rightsup-staging.com:180`.

### POSTMAN and examples

We love postman application to test our API, and we've created a collection of examples that you can play against our staging api right out of the box. Just follow this link [https://www.getpostman.com/collections/6d79728607c8c71d266e](https://www.getpostman.com/collections/6d79728607c8c71d266e) or this button:

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/6d79728607c8c71d266e)

### Authenticate and get a token

We use [JSON Web Tokens](http://jwt.io) to authenticate all API actions. These tokens are valid for 10 hours and require an existing RightsUp account. For testing purposes we've made an account in our test sandbox anyone can use. If you want get setup with a produciton account [get in touch](mailto:it@rightsup.com).

#### Authenticate: `POST  http://www.rightsup-staging.com:180/auth`

**Payload example:**

```json
{
    "username": "test-user@rightsup.com",
    "password": "password"
}
```

**Returns:**

```json
{
  "status": "authenticated",
  "credentials": {
    "id_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3JpZ2h0c3VwLmV1LmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1NzZhNWQxNzM3NjY3NTNhNjg2ZGQxYjMiLCJhdWQiOiJSNlRuZDY5SE5QNVZRNVlJcU5weHc3cnBqVnUyUU5DdSIsImV4cCI6MTQ2NjYyNTU0NSwiaWF0IjoxNDY2NTg5NTQ1fQ.LWxvjkukgbBJeL__1YQn8YG7vkrkPRWvWvNQAULRfa8",
    "access_token": "NwnffbJcEx0in9Cy",
    "token_type": "bearer"
  }
}
```

The resulting `id_token` is a JSON Web Token (JWT learn more [here](https://jwt.io/)) signed with a private key.

Use this token to authenticate future requests by including the **HTTP Header** with your correct JWT. It should be sent in the **AUTHORIZATION** field as a *Bearer* token.

For Example:

```
AUTHORIZATION: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3JpZ2h0c3VwLmV1LmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1NzZhNWQxNzM3NjY3NTNhNjg2ZGQxYjMiLCJhdWQiOiJSNlRuZDY5SE5QNVZRNVlJcU5weHc3cnBqVnUyUU5DdSIsImV4cCI6MTQ2NjYyNTU0NSwiaWF0IjoxNDY2NTg5NTQ1fQ.LWxvjkukgbBJeL__1YQn8YG7vkrkPRWvWvNQAULRfa8
```

### [<span aria-hidden="true" class="octicon octicon-link"></span>](#accounts)Client's account

We provide an endpoint to create a new client, which will return a `client_slug` which should be used for every client actions.

##### Create client as producer: `POST http://www.rightsup-staging.com:180/clients/producers`

**Payload example:**

```json
{
  "client": {
    "company_name": "Big Poppa",
    "country_code": "BE"
  },
  "user": {
    "email": "hello@rightsup.com"
  }
}
```

**Returns:**

```json
{
  "client": {
    "slug": "RU0012",
    "name": "Big Poppa",
    "client_type": "producer",
    "signed_contract": false,
    "users": [
      {
        "email": "hello@rightsup.com"
      }
    ],
    "archived": false
  }
}
```

### [<span aria-hidden="true" class="octicon octicon-link"></span>](#accounts)Music Repertoire

The only way to import data is Rights'Up system, is by importing complete release, including recordings metadata. You may (and you should) provide your internal id in the `external_ids` fields. These can be specified for recording, artist, label and release.

##### Import a release `POST http://www.rightsup-staging.com:180/releases`

`client_slug` is the client slug given when creating a new client account. `release` is the full payload of the release, including recordings metadata. Use `external_ids` field on Artist, Recording, Release to provide use your internal id of the resource. Contact us to allow the system to receive your provider name. **Payload example:**

```json
{
    "client_slug": "RU0045",
    "release": {
        "title": "Empty / Lohn Brot",
        "labels": [{
            "label": {
                "name": "liebe*detail",
                "external_ids": [{
                    "id": "label_31027",
                    "provider_name": "Discogs"
                }]
            },
            "catalog_number": "ld14"
        }],
        "release_types": ["12\""],
        "release_events": [{
            "date": "2006-01-01",
            "area": {
                "country_codes": ["DE"]
            }
        }],
        "credited_artists": [{
            "artist": {
                "name": "Angelo Battilani",
                "external_ids": [{
                    "id": "673962",
                    "provider_name": "Discogs"
                }]
            },
            "join": "/",
            "roles": []
        }, {
            "artist": {
                "name": "Efdemin",
                "external_ids": [{
                    "id": "77593",
                    "provider_name": "Discogs"
                }]
            },
            "join": null,
            "roles": []
        }],
        "extra_artists": [{
            "artist": {
                "name": "Giraffentoast",
                "external_ids": [{
                    "id": "252235",
                    "provider_name": "Discogs"
                }]
            },
            "join": null,
            "roles": ["Design"]
        }, {
            "artist": {
                "name": "Joachim Hinsch",
                "external_ids": [{
                    "id": "429857",
                    "provider_name": "Discogs"
                }]
            },
            "join": null,
            "roles": ["Lacquer Cut By"]
        }],
        "medias": [{
            "types": ["12\""],
            "format": "Vinyl",
            "track_count": 2,
            "tracks": [{
                "position": "A",
                "recording": {
                    "display_artist": "Angelo Battilani ,",
                    "display_title": "Empty",
                    "credited_artists": [{
                        "artist": {
                            "name": "Angelo Battilani",
                            "external_ids": [{
                                "id": "673962",
                                "provider_name": "Discogs"
                            }]
                        },
                        "join": ",",
                        "roles": []
                    }],
                    "extra_artists": [],
                    "genres": ["Electronic", "Minimal", "Tech House"],
                    "is_music_video": false
                }
            }, {
                "position": "B",
                "recording": {
                    "display_artist": "Efdemin ,",
                    "display_title": "Lohn Brot",
                    "credited_artists": [{
                        "artist": {
                            "name": "Efdemin",
                            "external_ids": [{
                                "id": "77593",
                                "provider_name": "Discogs"
                            }]
                        },
                        "join": ",",
                        "roles": []
                    }],
                    "extra_artists": [],
                    "genres": ["Electronic", "Minimal", "Tech House"],
                    "is_music_video": false
                }
            }],
            "title": "Hier"
        }],
        "external_ids": [{
            "id": "851082",
            "provider_name": "Discogs"
        }],
        "data_quality": "Needs Vote",
        "notes": "Made in Germany"
    },
    "master_release": {
        "title": "Empty / Lohn Brot",
        "artists": [{
            "name": "Angelo Battilani",
            "external_ids": [{
                "id": "673962",
                "provider_name": "Discogs"
            }]
        }, {
            "name": "Efdemin",
            "external_ids": [{
                "id": "77593",
                "provider_name": "Discogs"
            }]
        }],
        "first_release_year": 2006,
        "external_ids": [{
            "id": "358550",
            "provider_name": "Discogs"
        }],
        "main_release": {
            "external_ids": [{
                "id": "851082",
                "provider_name": "Discogs"
            }]
        }
    }
}
```

##### Getting releases `POST http://www.rightsup-staging.com:180/releases/unclaimed?client_slug=RUXXXX&includes=recordings,artists`

Since we created a client, we received the client_slug RU0045 that we used to import a release. Not lets fetch this client's releases.

```json
{
  "pagination": {
    "total": 1,
    "skip": 0,
    "limit": 20
  },
  "releases": [
    {
      "type": "release",
      "redirect_ids": null,
      "redirect_reason": null,
      "title": "Empty / Lohn Brot",
      "labels": [
        {
          "label": {
            "id": "04f28cd48b124bb2af78156390c9d538"
          },
          "catalog_number": "ld14"
        }
      ],
      "bar_code": null,
      "sdrm_code": null,
      "release_types": [
        "12\""
      ],
      "c_line": null,
      "distributor": null,
      "medias": [
        {
          "types": [
            "12\""
          ],
          "format": "Vinyl",
          "track_count": 2,
          "tracks": [
            {
              "position": "A",
              "recording": {
                "type": "recording",
                "redirect_ids": null,
                "redirect_reason": null,
                "display_title": "Empty",
                "display_artist": "Angelo Battilani ,",
                "duration_ms": null,
                "title": null,
                "version": null,
                "isrcs": null,
                "genres": [
                  "Electronic",
                  "Minimal",
                  "Tech House"
                ],
                "p_line": null,
                "is_music_video": false,
                "recording_country_code": null,
                "credited_artists": [
                  {
                    "artist": {
                      "type": "artist",
                      "redirect_ids": null,
                      "redirect_reason": null,
                      "name": "Angelo Battilani",
                      "external_ids": [
                        {
                          "id": "673962",
                          "provider_name": "Discogs"
                        }
                      ],
                      "external_id": null,
                      "artist_ids": null,
                      "deezer_extras": null,
                      "id": "20dacd9bf1c84edd8639a4433c3b6048"
                    },
                    "join": ","
                  }
                ],
                "extra_artists": [],
                "external_id": null,
                "external_ids": null,
                "library_type": null,
                "publisher": null,
                "explicit_lyrics": null,
                "deezer_extras": null,
                "bpm": null,
                "client_slugs": [
                  "RU0045"
                ],
                "client_claim_slugs": [],
                "id": "cf870774bafb4450adf87d1470700e23"
              },
              "id": "0adbe0da04e9443b9bca0b0a147ce73f"
            },
            {
              "position": "B",
              "recording": {
                "type": "recording",
                "redirect_ids": null,
                "redirect_reason": null,
                "display_title": "Lohn Brot",
                "display_artist": "Efdemin ,",
                "duration_ms": null,
                "title": null,
                "version": null,
                "isrcs": null,
                "genres": [
                  "Electronic",
                  "Minimal",
                  "Tech House"
                ],
                "p_line": null,
                "is_music_video": false,
                "recording_country_code": null,
                "credited_artists": [
                  {
                    "artist": {
                      "type": "artist",
                      "redirect_ids": null,
                      "redirect_reason": null,
                      "name": "Efdemin",
                      "external_ids": [
                        {
                          "id": "77593",
                          "provider_name": "Discogs"
                        }
                      ],
                      "external_id": null,
                      "artist_ids": null,
                      "deezer_extras": null,
                      "id": "7ef251074a48453db197d47456dc940e"
                    },
                    "join": ","
                  }
                ],
                "extra_artists": [],
                "external_id": null,
                "external_ids": null,
                "library_type": null,
                "publisher": null,
                "explicit_lyrics": null,
                "deezer_extras": null,
                "bpm": null,
                "client_slugs": [
                  "RU0045"
                ],
                "client_claim_slugs": [],
                "id": "d8d40fe9c7de46579afdbe9b9fb57ddb"
              },
              "id": "7da62d038e0e43e69e166a105b5d9663"
            }
          ],
          "title": "Hier",
          "id": "82262ca4517641cdabd79beceb55615c"
        }
      ],
      "release_events": [
        {
          "date": "2006-01-01",
          "area": {
            "name": null,
            "country_codes": [
              "DE"
            ]
          }
        }
      ],
      "external_ids": [
        {
          "id": "851082",
          "provider_name": "Discogs"
        }
      ],
      "external_id": null,
      "credited_artists": [
        {
          "artist": {
            "type": "artist",
            "redirect_ids": null,
            "redirect_reason": null,
            "name": "Angelo Battilani",
            "external_ids": [
              {
                "id": "673962",
                "provider_name": "Discogs"
              }
            ],
            "external_id": null,
            "artist_ids": null,
            "deezer_extras": null,
            "id": "20dacd9bf1c84edd8639a4433c3b6048"
          },
          "join": "/"
        },
        {
          "artist": {
            "type": "artist",
            "redirect_ids": null,
            "redirect_reason": null,
            "name": "Efdemin",
            "external_ids": [
              {
                "id": "77593",
                "provider_name": "Discogs"
              }
            ],
            "external_id": null,
            "artist_ids": null,
            "deezer_extras": null,
            "id": "7ef251074a48453db197d47456dc940e"
          }
        }
      ],
      "extra_artists": [
        {
          "artist": {
            "type": "artist",
            "redirect_ids": null,
            "redirect_reason": null,
            "name": "Giraffentoast",
            "external_ids": [
              {
                "id": "252235",
                "provider_name": "Discogs"
              }
            ],
            "external_id": null,
            "artist_ids": null,
            "deezer_extras": null,
            "id": "ebc20035236348bb948345f38eab41ef"
          },
          "roles": [
            "Design"
          ]
        },
        {
          "artist": {
            "type": "artist",
            "redirect_ids": null,
            "redirect_reason": null,
            "name": "Joachim Hinsch",
            "external_ids": [
              {
                "id": "429857",
                "provider_name": "Discogs"
              }
            ],
            "external_id": null,
            "artist_ids": null,
            "deezer_extras": null,
            "id": "411ca77f0c5e4d39913c839e975e100e"
          },
          "roles": [
            "Lacquer Cut By"
          ]
        }
      ],
      "notes": "Made in Germany",
      "data_quality": "Needs Vote",
      "imported_at": "2016-06-13 14:25:09.784421071 UTC",
      "genres": null,
      "deezer_extras": null,
      "client_slugs": [
        "RU0045"
      ],
      "client_claim_slugs": [],
      "id": "57dfe426d36f47458a169f23af85437b"
    }
  ]
}
```

### Claims

Claiming neighbouring rights is applied at the recording level. You'll need to use the recording ids when getting the release to claim those. The documentation is available in the POSTMAN collection.

### [<span aria-hidden="true" class="octicon octicon-link"></span>](#support-or-contact)Support or Contact

Having trouble with this documentation? Contribute to [https://github.com/rightsup/rightsup.github.io](https://github.com/rightsup/rightsup.github.io) or [contact us](mailto:it@rightsup.com) and we’ll help you sort it out.
