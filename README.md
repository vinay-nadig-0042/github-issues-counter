Github Issues Counter
---------------------

Simple Web App to fetch the following metrics from a public Github Repo

* Total number of open issues

* Number of open issues that were opened in the last 24 hours

* Number of open issues that were opened more than 24 hours ago but less than 7 days ago

* Number of open issues that were opened more than 7 days ago 

[Link to Heroku App](http://github-issues-counter.herokuapp.com/)


Process
-------

1. The app is a Sinatra App that uses [Octokit](https://github.com/octokit/octokit.rb/) library to access Github API
2. There are two simple routes defined. `GET /` & `POST /gihub-issues`
3. An input field takes the github url(should be a https Github url, ssh format not supported as of now)
4. An AJAX call is made to the backend server with the body consisting of the url entered.
5. The App validates that the URL is valid and that it's a valid Github URL. If not, an error is returned to the client.
5. The App parses the username & reponame from the url & accesses the Github API to fetch the list of issues for the project.(Pagination for large number of issues are handled by Octokit)
6. List of issues created during the last 24 hours, List of issues created during the last 7 days & List of all issues are constructed from the issue list.
7. Once all the issues are fetched, the required metrics are derived from the issue list & sent back as a response if the call succeeds.
7. Number of open issues that were opened more than 24 hours ago but less than 7 days ago is calculated as
    ```
    Last Week Issues Count - Last 24 hours Issues Count
    ```
8. Number of open issues that were opened more than 7 days ago is calculated as
    ```
    Total Issues Count - Last Week Issues Count
    ```
7. If the call does not succeed, a error message is sent back.
8. The client receives the metrics & updates the web page with the metrics.


Improvements
------------

1. No client side validations yet. Could be added for faster feedback.
2. All github related methods & errors are defined in [GithubHelpers](helpers/github_helpers.rb). The errors can be moved to a separate module for a cleaner Interface.
3. [Github API Token](https://github.com/blog/1509-personal-api-tokens) is used which limits the API request rate to 5000 req/hour. Could be a problem if there are a lot of simultaneous requests for Repos which contain [large number of issues](https://github.com/rails/rails/issues)
4. We fetch a list of all the issues to just get the count of issues right now. Involves a lot of bandwidth wastage at the cost of ease of development. A better approach would be to use the [since](https://developer.github.com/v3/issues/#parameters) parameter from the [list issues endpoint](https://developer.github.com/v3/issues/#list-issues)

