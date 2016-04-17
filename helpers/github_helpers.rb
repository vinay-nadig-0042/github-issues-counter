# A set of helpers loosely based on Regex to extract
# Repo & issue information from a github URL
module GithubHelpers
  # Regex to match Github Username & Reponame from URL
  GITHUB_URL_REGEX = %r{:\/\/github.com\/(.*?)\/(.*)(\/*)}
  DAY_IN_SECONDS = 60 * 60 * 24

  # Check if it's a valid URL and if it's a valid Github URL
  def valid_github_url?(url)
    return false if url.nil? || url.empty?
    return false unless URI.regexp.match url
    return false unless GITHUB_URL_REGEX.match url
    true
  end

  # Parse username from Github URL
  def github_username(url)
    GITHUB_URL_REGEX.match(url) ? GITHUB_URL_REGEX.match(url)[1] : nil
  end

  # Parse reponame from Github URL
  def github_reponame(url)
    GITHUB_URL_REGEX.match(url) ? GITHUB_URL_REGEX.match(url)[2].delete('/') : nil
  end

  # Strip all issues that are pull requests
  # https://developer.github.com/v3/issues/#list-issues-for-a-repository
  def strip_pull_requests_from_issues(issues)
    issues.select { |issue| issue.pull_request.nil? }.compact
  end

  def last_day_issues(issues)
    issues.select { |issue| (issue.created_at > (Time.now - DAY_IN_SECONDS)) }
  end

  def last_week_issues(issues)
    issues.select { |issue| issue.created_at > (Time.now - 7 * DAY_IN_SECONDS) }
  end

  # Errors

  def invalid_github_url_error
    { error: 'Invalid Github URL!' }
  end

  def repo_not_found_error
    { error: 'Repo not found! Make sure the link you have entered is valid.' }
  end
end
