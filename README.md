# Excelsior!

A real-time feedback app. Give (private, anonymous) feedback to your coworkers, or appreciate
them publicly for going above and beyond.

## Setup

*  requires postgreSQL
*  add initial users to the seed_email_list.csv file

## Configuration
There are a number of config variables that are needed to configure this app for your use:

### Email configuration
ALLOWED_EMAIL_DOMAINS (to restrict login to certain domains: 'gmail.com,anotherdomain.com')

ALLOWED_EMAILS (for test; send emails only to these emails: 'my.email@gmail.com,another.email@gmail.com')

DEFAULT_FROM_EMAIL (the "from" address on emails: 'Excelsior! <donotreply@mydomain.com>')

EMAIL_FOOTER_SIGNOFF (Thanks for being Excelsior!)

HOST (whatever.heroku.com)

SENDGRID_DOMAIN (heroku.com)

SENDGRID_PASSWORD (your sendgrid password)

SENDGRID_USERNAME (your sendgrid username)

### Controlling features via deployment
DEPLOYMENT (for deploying to multiple environments: 'stage||production')

RACK_ENV (production)

RAILS_ENV (production)

### Slack Integration
SLACK_CHANNEL (the slack channel appreciations will be sent to e.g. #whatever) 
  
SLACK_CHANNEL_URL (the url associated with the above channel)
  
SLACK_URL (the url for your slack integration)


### General Oauth, security, and addon config
DEVISE_SECRET_KEY (your secret devise key)

GOOGLE_CLIENT_ID (your Google OAuth Key)

GOOGLE_CLIENT_SECRET (your Google Oauth client secret)

PAPERTRAIL_API_TOKEN (your papertrail api token)


