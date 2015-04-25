# Description:
#   This should be the badoo service for our hubot

# Commands:
#   hubot icebreaker-suggest - Get a suggestion of an icebreaker you would want to deploy
#   hubot icebreaker-deploy <icebreaker> - Deploy a selected icebreaker

module.exports = (robot) ->
  icebreakers = ["$0: Hey, bae\ncome hang with me this saturday!", "$1 Hey, bae\nbye bae"]
  robot.respond /icebreaker-suggest/i, (res) ->
    icebreakerRandomIndex = Math.floor Math.random() * icebreakers.length

    icebreaker = icebreakers[icebreakerRandomIndex]

    if icebreaker
      res.reply icebreaker
    else
      res.reply "hey bae"

  robot.hear /icebreaker-deploy (.*)/i, (res) ->
    res.reply "deploying icebreaker!"
