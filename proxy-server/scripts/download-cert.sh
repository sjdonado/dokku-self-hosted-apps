#!/bin/sh

CONTENT_TYPE=application/text
FILE_NAME=proxy.crt
FILE_PATH=/usr/local/certs/proxy.crt

echo "Config server started, download your $FILE_NAME config at http://localhost:8080/"
echo "NOTE: After you download $FILE_NAME, http server will be shut down!"

{ echo -ne "HTTP/1.1 200 OK\r\nContent-Length: $(wc -c <$FILE_PATH)\r\nContent-Type: $CONTENT_TYPE\r\nContent-Disposition: attachment; fileName=\"$FILE_NAME\"\r\nAccept-Ranges: bytes\r\n\r\n"; cat "$FILE_PATH"; } | nc -w0 -l 8080

echo "Config http server has been shut down"
