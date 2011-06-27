Sidekick
========

[Sidekick](http://jostein.be/Ruby/Hacking/2011/02/22/automate-common-development-tasks-with-sidekick.html) is a command line tool to automatically trigger actions on certain events, as defined per project, in a local `.sidekick` file in your project folder. It is a simpler alterative to [Guard](https://github.com/guard/guard). If Guard is an engineering office, then Sidekick is duct tape. Here is a sample:

```ruby

  watch('**/*.rb') { restart_passenger; rake 'docs' }

  auto_compile 'assets/*.sass', 'public/:name.css'

  every(10) { notify sh 'fortune' }

```

### Sample use cases

* Restart server when code changes
* Auto-compile Sass or CoffeeScript templates (and many other languages)
* Periodically run tasks
* Continuous testing, notifications, hooks, you name it, the world is yours to conquer!

### Features

* Simple and powerful DSL
* Easy to extend
* Notifications using Growl or libnotify
* Compiles many formats, thanks to [Tilt]:(http://github.com/rtomayko/tilt).
* Powered by [EventMachine](http://github.com/eventmachine/eventmachine)
* Brief and concise codebase.

### Basic usage

Install with `gem install sidekick` and invoke the `sidekick` command in your project folder. If you do not have a `.sidekick` file, you will be offered a [template](https://github.com/jbe/sidekick/blob/master/lib/sidekick/template) with plenty of examples.

### Defining new triggers

Have a look at the [existing triggers](https://github.com/jbe/sidekick/blob/master/lib/sidekick/actions/triggers.rb), and you will get the idea. Basically, you define new triggers by writing methods that hook into [EventMachine](http://github.com/eventmachine/eventmachine) the same way as in `EM.run { .. }`.

If you write some useful extensions, ask me to merge them into the main repository!

---

Copyright (c) 2010 Jostein Berre Eliassen. See LICENSE for details.
