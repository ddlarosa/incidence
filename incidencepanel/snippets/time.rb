class Time

  ONE_MINUTE = 60
  ONE_HOUR = 60 * ONE_MINUTE
  ONE_DAY = 24 * ONE_HOUR
  ONE_WEEK = 7 * ONE_DAY
  ONE_MONTH = ONE_DAY * 3652425 / 120000
  ONE_YEAR = ONE_DAY * 3652425 / 10000

  def ago_in_words
    seconds_ago = (Time.now - self).to_i
    return "at some point in the future" if seconds_ago < 0
    return "just now" if seconds_ago == 0
    return "1 second ago" if seconds_ago == 1
    return "#{seconds_ago} seconds ago" if seconds_ago < ONE_MINUTE
    return "1 minute ago" if seconds_ago < 2 * ONE_MINUTE
    return "#{seconds_ago / ONE_MINUTE} minutes ago" if seconds_ago < ONE_HOUR
    return "1 hour ago" if seconds_ago < 2 * ONE_HOUR
    return "#{seconds_ago / ONE_HOUR} hours ago" if seconds_ago < ONE_DAY
    return "1 day ago" if seconds_ago < 2 * ONE_DAY
    return "#{seconds_ago / ONE_DAY} days ago" if seconds_ago < ONE_WEEK
    return "1 week ago" if seconds_ago < 2 * ONE_WEEK
    return "#{seconds_ago / ONE_WEEK} weeks ago" if seconds_ago < ONE_MONTH
    return "1 month ago" if seconds_ago < 2 * ONE_MONTH
    return "#{seconds_ago / ONE_MONTH} months ago" if seconds_ago < ONE_YEAR
    return "1 year ago" if seconds_ago < 2 * ONE_YEAR
    return "#{seconds_ago / ONE_YEAR} years ago"
  end
end
