#!/usr/bin/env ruby

require 'sinatra'
require 'octokit'
require 'sinatra/json'
require 'uri'
require 'json'
require './helpers/github_helpers'
require 'pry' if development?

include GithubHelpers

helpers do
  # We get only total number of issues, issues opened in last 24 hours
  # and issues opened in last week. All the other values that are required
  # can be derived from these values

  # Issues opened more than 7 days ago = Total Issue Count - Last week's Issues Count
  # Issues opened more than 24 hours ago but less than 7 days ago
  #          = Last Week Issues Count - Last Day issues count
  def get_issue_stats(url)
    return invalid_github_url_error unless valid_github_url? url
    username = github_username(url)
    reponame = github_reponame(url)
    begin
      all_issues = Octokit.list_issues "#{username}/#{reponame}"
    rescue Octokit::NotFound
      return repo_not_found_error
    end
    issues = strip_pull_requests_from_issues(all_issues)
    last_day_issues = last_day_issues(issues)
    last_week_issues = last_week_issues(issues)
    {
      last_day: last_day_issues.count,
      mt_7d: issues.count - last_week_issues.count,
      mt_24h_lt_7d: last_week_issues.count - last_day_issues.count,
      total: issues.count
    }
  end
end

Octokit.configure do |c|
  c.access_token = ENV['GITHUB_ACCESS_TOKEN']
  c.auto_paginate = true
end

get '/' do
  erb :index
end

post '/github-issues' do
  url = params['url']
  json get_issue_stats(url)
end
