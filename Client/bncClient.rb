require "socket"

port = 9004

host = "localhost"

sock = TCPSocket.new(host, port)

input = "again"
while true
	dataFromServer = sock.gets
	puts dataFromServer unless dataFromServer.casecmp("exit case") == 0
	if (dataFromServer.chomp.casecmp("goodbye") == 0)
		break
	else
		if (dataFromServer.include? ":")
			input = gets
			sock.puts input
		else
			sock.puts " "
		end
	end
end

sock.close
