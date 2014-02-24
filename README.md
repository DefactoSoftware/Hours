Hours
=====

[![Build Status](https://magnum.travis-ci.com/DefactoSoftware/Hours.png?token=A49pyqNGPBpMX52bcsLm)](https://magnum.travis-ci.com/DefactoSoftware/Hours)

System Dependencies
-------------------
- Ruby 2.1.0 (install with [rbenv](https://github.com/sstephenson/rbenv))
- Rubygems
- Bundler (`gem install bundler`)
- PostgreSQL

Getting Started
---------------

This repository comes equipped with a self-setup script:

    % ./bin/setup

After setting up, you can run the application using [foreman]:

    % foreman start

[foreman]: http://ddollar.github.io/foreman/

Guidelines
----------
- Write specs!
- Development happens on the `development` branch only, if something is finished open a pull-request to master. Master should always be ready for deployment.
- Please adhere to the [Github ruby styleguide](https://github.com/styleguide/ruby)
- All code and commit messages should be in English
- Commit messages are written in the imperative with a short, descriptive title. Good => `Return a 204 when updating a question`, bad => `Changed http response` or `I updated the http response on the update action in the QuestionController because we're not showing any data there`. The first line should always be 50 characters or less and that it should be followed by a blank line.
Use the following guides for getting things done, programming well, and
programming in style.
