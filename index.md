---
layout: default
---

### [<span aria-hidden="true" class="octicon octicon-link"></span>](#overview)Welcome to Rights'Up API documentation.

All requests should be made against our Staging API endpoint: `http://www.rightsup-staging.com:180`.

### POSTMAN and examples

We love postman application for API testing, we've created a collection of examples that you can play against our staging api right out of the box. Just follow this link [https://www.getpostman.com/collections/6d79728607c8c71d266e](https://www.getpostman.com/collections/6d79728607c8c71d266e) or this button:

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/6d79728607c8c71d266e)

### Set an Environment

Our example suite relies on stored environment variables to keep your authorization token. You'll need to create an environment to run the suite correctly. Create a new empty environment to store the JWT between requests.

![Imgur](http://i.imgur.com/f5GUpHB.gif)

### Authenticate and get a token

We use [JSON Web Tokens](http://jwt.io) to authenticate all API actions. These tokens are valid for 10 hours and require an existing RightsUp account. For testing purposes we've made an account in our test sandbox anyone can use. If you want get setup with a production account [get in touch](mailto:it@rightsup.com).

#### Authenticate: `POST  /auth`

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

The resulting `id_token` is a JSON Web Token ([JWT learn more here](https://jwt.io/)) signed with a private key.

Use this token to authenticate future requests by including the **HTTP Header** with your correct JWT. It should be sent in the **AUTHORIZATION** field as a *Bearer* token.

For Example:

```
AUTHORIZATION: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3JpZ2h0c3VwLmV1LmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1NzZhNWQxNzM3NjY3NTNhNjg2ZGQxYjMiLCJhdWQiOiJSNlRuZDY5SE5QNVZRNVlJcU5weHc3cnBqVnUyUU5DdSIsImV4cCI6MTQ2NjYyNTU0NSwiaWF0IjoxNDY2NTg5NTQ1fQ.LWxvjkukgbBJeL__1YQn8YG7vkrkPRWvWvNQAULRfa8
```

### [<span aria-hidden="true" class="octicon octicon-link"></span>](#accounts)Client's account

We provide an endpoint to create a new client, which will return a `client_slug` which should be used for every client actions. It will have a format like `RU0001`.

##### Create client as producer: `POST /clients/producers`

### [<span aria-hidden="true" class="octicon octicon-link"></span>](#accounts)Music Repertoire

The only way to import data into Rights'Up is importing complete release, including recordings metadata. You may (and should) provide your internal id in the `external_ids` fields. These can be specified for recording, artist, label and release. By providing such ID, we'll avoid creating duplicates and make your life easier.

##### Import a release `POST /releases`  

##### Getting releases `GET /releases/unclaimed?client_slug=RUXXXX&includes=recordings,artists`  

##### Getting one releases `GET /releases/:id?includes=recordings,artists`  

### Claims

Neighbouring rights claims are applied at the recording level. You'll need to fetch recording ids from one of the release endpoints. Recordings can be claimed in batches. Typically the recordings for a whole release should be claimed in one batch.

##### Claim recordings as master owner `POST /producer_claims/master`  

##### Claim recordings as licensee `POST /producer_claims/licensee`  

### [<span aria-hidden="true" class="octicon octicon-link"></span>](#support-or-contact)Support or Contact

Having trouble with this documentation? Contribute to [https://github.com/rightsup/rightsup.github.io](https://github.com/rightsup/rightsup.github.io) or [contact us](mailto:it@rightsup.com) and we’ll help you sort it out.
