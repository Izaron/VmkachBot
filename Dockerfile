# Grab the latest Ubuntu image
FROM ubuntu:latest

# Install luarocks and dependencies
RUN apt-get update
RUN \
    apt-get install -y \
        luarocks \
        libssl-dev

# Install Lua bot dependencies
RUN luarocks install telegram-bot-lua
RUN luarocks install inspect
RUN luarocks install stringy
RUN luarocks install lua-requests

# Copy the code and set workdir
ADD ./src /opt/src/
WORKDIR /opt/src

# Run the app. CMD is required to run on Heroku
CMD lua5.1 bot.lua
