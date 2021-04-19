#!/usr/bin/env ruby
Thread.new do
  duration = 10.minutes
  interval = 5.seconds
  time_remaining = duration.seconds / interval.seconds

  while(time_remaining > 0) do
    echo "Time remaining: #{time_remaining}"
    time_remaining -= 1
    sleep(interval)
  end
end
