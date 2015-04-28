# Description:
#   This should be the badoo service for our hubot

# Commands:
#   hubot icebreaker-suggest - Get a suggestion of an icebreaker you would want to deploy
#   hubot icebreaker-deploy <icebreaker> - Deploy a selected icebreaker

module.exports = (robot) ->

  # Mockable API demo configuration demo0986277.mockable.io
  robot.respond /prepare/i, (res) ->
    # icebreakerRandomIndex = Math.floor Math.random() * icebreakers.length

    # Send a request to get a prepared-statement
    res.robot.http("http://demo0986277.mockable.io/ice-breaker/prepare").get() (err, response, body) ->

      if response.statusCode == 200

        responseContent = JSON.parse(body)

        if responseContent.hasOwnProperty("message")

          # Split the message into partials and prefix each partial with a quote marker
          message = responseContent.message.split "\n"
          messagePartialDisplay = []
          for m in message
            m = ">" + m
            messagePartialDisplay.push(m)

          res.reply "Prepared statement: \n" + messagePartialDisplay.join "\n"

        else
          res.reply "There is something wrong :("

      else
        res.reply "There is something wrong :("

  robot.respond /deploy/i, (res) ->
    res.robot.http("http://demo0986277.mockable.io/ice-breaker/deploy").put() (err, response, body) ->
      if response.statusCode == 200
        responseContent = JSON.parse(body)

        if responseContent.hasOwnProperty("message")
          res.reply responseContent.message + " :)"
        else
          res.reply "There is something wrong :("

      else
        res.reply "There is something wrong :("

#  Register a user.
#  @TODO: go to bed
#  robot.respond /register/i, (message) ->
#    message.robot.http().post() (err, response, body) ->
#
#      if response.statusCode == 201
#        responseContent = JSON.parse(body)
#
#        if responseContent.hasOwnProperty("message")
#          message.reply responseContent.message
#
#        else
#          message.reply "Something went wrong"
#
#      else
#        message.reply "Something went wrong"
