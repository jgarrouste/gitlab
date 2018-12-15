#!/bin/bash

set -e

ENV_FILE=".env"

read_properties()
{
  file=$1
  while IFS="=" read -r key value; do
    case "$key" in
      "GITLAB_VERSION") GITLAB_VERSION="$value" ;;
      "SSL") SSL="$value" ;;
      "GITLAB_DOMAIN") GITLAB_DOMAIN="$value" ;;
      "GITLAB_VOLUME") GITLAB_VOLUME="$value" ;;
      "GITLAB_REGISTRY_DOMAIN") GITLAB_REGISTRY_DOMAIN="$value" ;;
      "SMTP_SERVER_DOMAIN") SMTP_SERVER_DOMAIN="$value" ;;
      "SMTP_USERNAME") SMTP_USERNAME="$value" ;;
      "SMTP_PASSWORD") SMTP_PASSWORD="$value" ;;
      "SMTP_DOMAIN") SMTP_DOMAIN="$value" ;;
    esac
  done < "$file"
}


write_properties()
{

  if [ -f $ENV_FILE ]; then
    DATE=$(date +'%Y-%m-%d-%H:%M:%S')
    cp .env ".env.$DATE"
  fi



  echo "# Set volume where gitlab data will is stored" >> "$ENV_FILE.tmp"
  echo "GITLAB_VOLUME=$GITLAB_VOLUME" >> "$ENV_FILE.tmp"

  echo "" >> "$ENV_FILE.tmp"
  echo "# Set your gitlab domain name" >> "$ENV_FILE.tmp"
  echo "GITLAB_DOMAIN=$GITLAB_DOMAIN" >> "$ENV_FILE.tmp"

  echo "" >> "$ENV_FILE.tmp"
  echo "# Set your gitlab docker registry domain" >> "$ENV_FILE.tmp"
  echo "GITLAB_REGISTRY_DOMAIN=$GITLAB_REGISTRY_DOMAIN" >> "$ENV_FILE.tmp"

  echo "" >> "$ENV_FILE.tmp"
  echo "# The path to store SSL materials If you want to access gitlab with https (mandatory for registry)" >> "$ENV_FILE.tmp"
  echo "SSL=$SSL" >> "$ENV_FILE.tmp"

  echo "" >> "$ENV_FILE.tmp"
  echo "# Set gitlab version" >> "$ENV_FILE.tmp"
  echo "GITLAB_VERSION=$GITLAB_VERSION" >> "$ENV_FILE.tmp"

  echo "" >> "$ENV_FILE.tmp"
  echo "# Set SMTP Server Domain" >> "$ENV_FILE.tmp"
  echo "SMTP_SERVER_DOMAIN=$SMTP_SERVER_DOMAIN" >> "$ENV_FILE.tmp"

  echo "" >> "$ENV_FILE.tmp"
  echo "# Set SMTP Username" >> "$ENV_FILE.tmp"
  echo "SMTP_USERNAME=$SMTP_USERNAME" >> "$ENV_FILE.tmp"

  echo "" >> "$ENV_FILE.tmp"
  echo "# Set SMTP password" >> "$ENV_FILE.tmp"
  echo "SMTP_PASSWORD=$SMTP_PASSWORD" >> "$ENV_FILE.tmp"

  echo "" >> "$ENV_FILE.tmp"
  echo "# Set user email domain" >> "$ENV_FILE.tmp"
  echo "SMTP_DOMAIN=$SMTP_DOMAIN" >> "$ENV_FILE.tmp"


  mv -f "$ENV_FILE.tmp" "$ENV_FILE"

}




read_properties $ENV_FILE

# Read Gitlab version
echo ""
echo "Which version of gitlab do you want to istall or upgrade to ($GITLAB_VERSION)?"
read value
if [ -n "${value}" ]; then
  GITLAB_VERSION=$value
fi

# Read GITLAB_DOMAIN
echo ""
echo "Enter your Gitlab domain ($GITLAB_DOMAIN)?"
read value
if [ -n "${value}" ]; then
  GITLAB_DOMAIN=$value
fi

# Read GITLAB_REGISTRY_DOMAIN
echo ""
echo "Enter your Gitlab registry domain ($GITLAB_REGISTRY_DOMAIN)?"
read value
if [ -n "${value}" ]; then
  GITLAB_REGISTRY_DOMAIN=$value
fi

# Read SSL Directory path
echo ""
echo "Directory to install SSL certificates ($SSL)?"
read value
if [ -n "${value}" ]; then
  SSL=$value
fi


# Read SMTP server domain
echo ""
echo "Enter a SMTP server domain for Gitlab to email users ($SMTP_SERVER_DOMAIN)?"
read value
if [ -n "${value}" ]; then
  SMTP_SERVER_DOMAIN=$value
fi

# Read SMTP USERNAME
echo ""
echo "Enter SMTP username ($SMTP_USERNAME)?"
read value
if [ -n "${value}" ]; then
  SMTP_USERNAME=$value
fi

# Read SMTP PASSWORD
echo ""
echo "Enter SMTP password (**********)?"
read -s value
if [ -n "${value}" ]; then
  SMTP_PASSWORD=$value
fi

# Read user email domain
echo ""
echo "Enter user email domain  ($SMTP_DOMAIN)?"
read value
if [ -n "${value}" ]; then
  SMTP_DOMAIN=$value
fi

echo "=================="
echo "GITLAB_VERSION=$GITLAB_VERSION"
echo "GITLAB_DOMAIN=$GITLAB_DOMAIN"
echo "GITLAB_REGISTRY_DOMAIN=$GITLAB_REGISTRY_DOMAIN"
echo "SSL=$SSL"
echo "SMTP_SERVER_DOMAIN=$SMTP_SERVER_DOMAIN"
echo "SMTP_USERNAME=$SMTP_USERNAME"
echo "SMTP_DOMAIN=$SMTP_DOMAIN"
echo "=================="

echo ""
echo "Do you want to override previous gitlab settings, build a new image and relaunch (y/n)?"
read value
value=$(echo $value | tr '[:upper:]' '[:lower:]')
if [ "$value" = "y" ]; then
  write_properties
  docker-compose build --no-cache
  echo "To launch gitlab, enter the following commands:"
  echo "docker-compose stop"
  echo "docker-compose up -d"
else
  exit 0
fi
