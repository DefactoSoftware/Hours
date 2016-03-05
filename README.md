Hours
=====

[![Build Status](https://travis-ci.org/DefactoSoftware/Hours.svg?branch=master)](https://travis-ci.org/DefactoSoftware/Hours)
[![Code Climate](https://codeclimate.com/github/DefactoSoftware/Hours/badges/gpa.svg)](https://codeclimate.com/github/DefactoSoftware/Hours)

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/DefactoSoftware/Hours)

Hours is a dead simple project based time tracking application that we use
for internal time-tracking. It allows users to register how many hours they've
worked on a project with a certain category (think `design`, `software development`,
`testing` for software teams) and add any tag they like to it. This gives us a lot of
insight on how we spend our time on different projects.

It looks like this:

<img src="http://i.imgur.com/UGotYJu.png" width=500 alt="Projects overview" />

<img src="http://i.imgur.com/SZd6Oaw.png" width=500 alt="Single project" />

<img src="http://i.imgur.com/gJxWWnc.png" width=500 alt="Entries" />

<img src="http://i.imgur.com/QfMsVjb.png" width=500 alt="Audit Log" />

<img src="http://i.imgur.com/y4RLCEg.png" width=500 alt="Entry" />




Roadmap
-------

As we're using Hours we're constantly thinking of ways to improve it and we'd love to hear your thoughts!

System Dependencies
-------------------

- Ruby 2.3.0 (install with [rbenv](https://github.com/sstephenson/rbenv))
- Rubygems
- Bundler (`gem install bundler`)
- PostgreSQL
- qmake (`brew install qt`) or read extensive instructions [here](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit)
- memcached (`brew install memcached`, an older version ships with OSX)(optional)

Getting Started
---------------

This repository comes equipped with a self-setup script:

    % ./bin/setup

After setting up, you can run the application using [foreman]:

    % foreman start

Since we're using subdomains to point to accounts, you can't run the app on localhost.
If you have [pow] set up, it will be automatically configured by the setup script, otherwise
you need to point apache/nginx to the port foreman is running the app on (7000 by default). With pow the app will run on http://hours.dev

In order to activate caching in development you can add `CACHE_DEVELOPMENT="anything"` to your `.env`. Make sure to run `$ memcached` when you do need this.

[foreman]: http://ddollar.github.io/foreman/
[pow]: http://pow.cx

Feature Flags
-------------

Description:

Single Tenant Mode: Initialize application in single tenant mode. Disabled by default.

Usage:

To use the single tenant mode, you can add SINGLE_TENANT_MODE to your enviroment variables with the value `true`. On development you can set this in your .env with `SINGLE_TENANT_MODE=true` and restart foreman. On heroku it's under the `Config Variables`.  
The first user in single tenant mode can be created by a rake task `rake create_user`. We'll ask you for your credentials.

Guidelines
----------
- Pull requests are welcome! If you aren't able to contribute code please open an issue on Github.
- Write specs!
- Develop features on dedicated feature branches, feel free to open a PR while it's still WIP
- Please adhere to the [Thoughtbot ruby styleguide](https://github.com/thoughtbot/guides/tree/master/style#ruby)
- All code and commit messages should be in English
- Commit messages are written in the imperative with a short, descriptive title. Good => `Return a 204 when updating a question`, bad => `Changed http response` or `I updated the http response on the update action in the QuestionController because we're not showing any data there`. The first line should always be 50 characters or less and that it should be followed by a blank line.
- Please localize all strings and add i18n keys to the locale files sorted by key in ascending order

License
-------
Hours is distributed under the MIT license.
