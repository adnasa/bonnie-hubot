# Description:
#   A DAAS I'm working on
#
# Commands:
#   hubot deploy

CONFIG = require("../local/config")

postHeaders =
  "Content-Type": "application/json"
  "Accept": "application/json"

module.exports = (robot) ->

  # Prepare a statement for the user
  robot.respond /prepare/i, (message) ->
    # icebreakerRandomIndex = Math.floor Math.random() * icebreakers.length

    # Send a request to get a prepared-statement
    message.robot.http(CONFIG.URL.PREPARE).get() (err, response, body) ->
      if response.statusCode == 200
        responseContent = JSON.parse(body)

        if responseContent.hasOwnProperty("message")

          # Split the message into partials and prefix each partial with a quote marker
          responseContentMessage = responseContent.message.split "\n"
          responseContentMessagePartialDisplay = []

          for m in responseContentMessage
            m = ">" + m
            responseContentMessagePartialDisplay.push(m)

          message.reply "Prepared statement: \n" + responseContentMessagePartialDisplay.join "\n"

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
  robot.respond /register (badoo|happypancake) (\w+) (\w+) (.*)/i, (message) ->
    messageMatch = message.match

    if (count(messageMatch) < 4)
      message.reply "Invalid registration"

    service = messageMatch[1]
    user    = messageMatch[2]
    pass    = messageMatch[3]
    token   = messageMatch[4]

    message.robot.http(CONFIG.URL.REGISTER).post() (err, responseObj, body) ->
      if (responseObj.statusCode >= 200 && responseObj.statusCode <= 300)
        responseContent = JSON.parse body

        if (responseContent.hasOwnProperty("message"))
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

