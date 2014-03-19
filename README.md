Hours
=====

[![Build Status](https://magnum.travis-ci.com/DefactoSoftware/Hours.png?token=A49pyqNGPBpMX52bcsLm)](https://magnum.travis-ci.com/DefactoSoftware/Hours)

System Dependencies
-------------------
- Ruby 2.1.0 (install with [rbenv](https://github.com/sstephenson/rbenv))
- Rubygems
- Bundler (`gem install bundler`)
- PostgreSQL
- qmake (`brew install qt`) or read extensive instructions [here](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit)

Getting Started
---------------
For local mail support you need to enter your gmail address and password in .sample.env file.

    GMAIL_USERNAME="example@mail.com"
    GMAIL_PASSWORD="password"

This repository comes equipped with a self-setup script:

    % ./bin/setup

After setting up, you can run the application using [foreman]:

    % foreman start

Since we're using subdomains to point to accounts, you can't run the app on localhost.
If you have [pow] set up, it will be automatically configured by the setup script, otherwise
you need to point apache/nginx to the port foreman is running the app on (7000 by default). With pow the app will run on http://hours.dev

[foreman]: http://ddollar.github.io/foreman/
[pow]: http://pow.cx

Guidelines
----------
- Write specs!
- Development happens on the `development` branch only, if something is finished open a pull-request to master. Master should always be ready for deployment.
- Please adhere to the [Github ruby styleguide](https://github.com/styleguide/ruby)
- All code and commit messages should be in English
- Commit messages are written in the imperative with a short, descriptive title. Good => `Return a 204 when updating a question`, bad => `Changed http response` or `I updated the http response on the update action in the QuestionController because we're not showing any data there`. The first line should always be 50 characters or less and that it should be followed by a blank line.
Use the following guides for getting things done, programming well, and
programming in style.
