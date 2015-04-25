module.exports = (robot) ->
  robot.hear /badoo/i, res ->
    res.send "What!?!"
