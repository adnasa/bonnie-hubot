# Description:
#   Messing around with the YouTube API.
#
# Commands:
#   hubot deploy

module.exports = (robot) ->

  # Prepare a statement for the user
  robot.respond /prepare/i, (message) ->
    # icebreakerRandomIndex = Math.floor Math.random() * icebreakers.length

    # Send a request to get a prepared-statement
    message.robot.http("http://demo0986277.mockable.io/ice-breaker/prepare").get() (err, response, body) ->
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
    message.robot.http("http://demo0986277.mockable.io/ice-breaker/deploy").put() (err, response, body) ->
      if response.statusCode == 200
        responseContent = JSON.parse(body)

        if responseContent.hasOwnProperty("message")
          message.reply responseContent.message + " :)"

  # Register a user for scraping capabilities
  robot.respond /register (badoo|happypancake) (\w+) (\w+) (.*)/i, (message) ->
    messageMatch = message.match
    service = messageMatch[1]
    user = messageMatch[2]
    pass = messageMatch[3]
    token = messageMatch[4]

    message.robot.http("http://demo0986277.mockable.io/user/register").post() (err, responseObj, body) ->
      if (responseObj.statusCode >= 200 && responseObj.statusCode <= 300)
        responseContent = JSON.parse body

        if (responseContent.hasOwnProperty("message"))
          message.reply responseContent.message
