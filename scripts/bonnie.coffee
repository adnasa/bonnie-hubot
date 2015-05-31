# Description:
#   A DAAS I'm working on
#
# Commands:
#   DAAS => hubot deploy: `:message` - Deploy a specific message. message is optional.
#   DAAS => hubot register `service` `username` `password` `TOKEN` - Register an account at a service
#   DAAS => hubot poll - Poll message from your registered service


CONFIG = require("../local/config")

postHeaders =
  "Content-Type": "application/json"
  "Accept": "application/json"

module.exports = (robot) ->

  # Deploy the statement that is prepared
  robot.respond /deploy/i, (message) ->
    rawMessageObject = message.message

    postMessage =
      user: rawMessageObject.user
      message: rawMessageObject.rawText

    message.robot.http(CONFIG.URL.DEPLOY)
      .headers(postHeaders)
      .post(JSON.stringify(postMessage)) (err, response, body) ->

        if response && response.statusCode == 200
          responseContent = JSON.parse(body)
          message.reply responseContent.message
        else
          message.reply "Something went wrong!"

  # Register a user for scraping capabilities
  robot.respond /register (\w+) (\w+) (\w+) (.*)/i, (message) ->
    messageMatch = message.match
    rawMessageObject = message.message

    if (messageMatch.length < 4)
      message.reply "Invalid registration"

    postMessage =
      user: rawMessageObject.user
      params:
        service  : messageMatch[1]
        name     : messageMatch[2]
        password : messageMatch[3]
        token    : messageMatch[4]

    message.robot.http(CONFIG.URL.REGISTER)
      .headers(postHeaders)
      .post(JSON.stringify(postMessage)) (err, response, body) ->

        if response && response.statusCode == 201
          responseContent = JSON.parse(body)
          message.reply responseContent.message


  # Pull messages from the registered service
  robot.respond /pull messages/i, (message) ->
    message.robot.http(CONFIG.URL.PULL_MESSAGES).get() (err, responseObj, body) ->
      if (responseObj.statusCode == 200)
        responseContent = JSON.parse body
        if (responseContent.hasOwnProperty("message") && responseContent.message != null)
          responseContentMessage = JSON.parse responseContent.message

          for item in responseContentMessage.list
            message.send item.username + ": " + item.message

