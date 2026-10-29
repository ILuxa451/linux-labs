#!/bin/bash
printf "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 20\r\nConnection: close\r\n\r\nHello from systemd!\n"
