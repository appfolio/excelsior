# Excelsior! [![CircleCI](https://circleci.com/gh/appfolio/excelsior/tree/master.svg?style=shield)](https://circleci.com/gh/appfolio/excelsior/tree/master)

An app to appreciate your coworkers publicly for going above and beyond.

## Setup

*  requires PostgreSQL
*  add initial users to the seed_email_list.csv file
*  requires free Sendgrid account
*  requires free Heroku account
*  requires free Google account

## Configuration

There are a number of config variables that are needed to configure this app for your use:

### Email configuration

ALLOWED_EMAIL_DOMAINS (to restrict login to certain domains: 'gmail.com,anotherdomain.com')

ALLOWED_EMAILS (for test; send emails only to these emails: 'my.email@gmail.com,another.email@gmail.com')

DEFAULT_FROM_EMAIL (the "from" address on emails: 'Excelsior! <donotreply@mydomain.com>', must be set up in Sendgrid)

EMAIL_FOOTER_SIGNOFF (e.g. "Thanks for being Excelsior!")

HOST (your-app-name.herokuapp.com)

SENDGRID_DOMAIN (heroku.com)

SENDGRID_PASSWORD (this should be your Sendgrid API Key)

SENDGRID_USERNAME (this should always be 'apikey')

### Controlling features via deployment

DEPLOYMENT (for deploying to multiple environments: 'stage||production')

RACK_ENV (production)

RAILS_ENV (production)

### Slack Integration

SLACK_CHANNEL (the slack channel appreciations will be sent to e.g. #whatever) 
  
SLACK_CHANNEL_URL (the url associated with the above channel)
  
SLACK_URL (the url for your slack integration)

### General OAuth, security, and addon config

DEVISE_SECRET_KEY (your secret Devise key)

GOOGLE_CLIENT_ID (your Google OAuth Key)

GOOGLE_CLIENT_SECRET (your Google Oauth client secret)

PAPERTRAIL_API_TOKEN (your Papertrail API token)


