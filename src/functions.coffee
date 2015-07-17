exports.name = 'rbash'
exports.desc = 'bash executor with restricted permission'

exports.setup = (telegram, ..., server, _) ->
	pkg = require '../package.json'

	[
			cmd: 'bash'
			args: '[exec|help]'
			desc: 'exec: execute bash script. Max execution time is 500ms. help: print available commands'
			num: 1
			opt: 1
			act: (msg, cmd) =>
				if cmd == 'help'
					# TODO
					telegram.sendMessage msg.chat.id, 'help'
				else
					server.grabInput msg.chat.id, msg.from.id, pkg.name, 'bash'
					telegram.sendMessage msg.chat.id, 'The Black Magic! Send me the script you want to execute.', msg.message_id
	]

exports.input = (cmd, msg, telegram, ..., server, config) ->
	# Release the input anyhow
	server.releaseInput msg.chat.id, msg.from.id

	if cmd is 'bash'
		bash = require './rbash'
		bash.exec config.rbash, config.rbashpath, msg.text, (res, code) =>
			if code is null
				exit = 'Timed out.'
			else
				exit = "Exited with #{code}"
			telegram.sendMessage msg.chat.id, "#{res}\n#{exit}", msg.message_id