# Newrelic::PJAX

Adds additional helper methods to the newrelic_rpm gem to allow instrumentation of PJAX requests

## Installation

Add this line to your application's Gemfile:

    gem 'newrelic-pjax'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install newrelic-pjax

## Usage

For PJAX requests, instead of rendering no template you'll need to render a PJAX template where we'll return some additional JavaScript to record response timing.

If you're using `pjax_rails` rails then add this to your application controller:


``` ruby
class ApplicationController < ActionController::Base
  protected

  def pjax_layout
    'pjax'
  end
end
```

Next create a PJAX layout like so:

```
# app/views/layouts/pjax.html.erb

<%= NewRelic::Agent.pjax_timing_start %>
<%= yield %>
<%= NewRelic::Agent.pjax_timing_end %>

```

Lastly in your applications JavaScript you will need to fire off timing information to newrelic once the PJAX request is complete. Here in the example below i'm using the [jquery.waitForImages JavaScript library](https://github.com/alexanderdickson/waitForImages) to calculate front end rendering time by timing how long the images take to render on the page.  

You can find the jquery.waitForImages library here [https://github.com/alexanderdickson/waitForImages](https://github.com/alexanderdickson/waitForImages)

```coffee
# app/assets/javascript/application.js

#= require jquery
#= require jquery.pjax
#= require jquery.waitforimages

$ ->
  $(document).on 'pjax:start', (xhr) ->
    window.pjaxTiming = {'navigationStart': new Date().getTime() }

  $(document).on 'pjax:end', (xhr) ->
    $('#main-inner').waitForImages ->
      if NREUMQ?
        currentTime = new Date().getTime()
        totalBeTime = pjaxTiming['firstByte'] - pjaxTiming['navigationStart']
        domTime     = pjaxTiming['lastByte'] - pjaxTiming['firstByte']
        feTime      = currentTime - pjaxTiming['firstByte']

        NREUM.inlineHit(pjaxTiming['transactionName'], pjaxTiming['queueTime'], pjaxTiming['appTime'], totalBeTime, domTime, feTime)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
