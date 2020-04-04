import cv2
import threading
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer
from SocketServer import ThreadingMixIn
from io import StringIO,BytesIO
from PIL import Image
import time
capture=None

num = 0

class CamHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.endswith('mjpg'):
            self.send_response(200)
            self.send_header('Content-type','multipart/x-mixed-replace; boundary=--jpgboundary')
            self.end_headers()
            running = True

            if(self.path.endswith("cam1.mjpg")):
                camera = capture[0]

            if(self.path.endswith("cam2.mjpg")):
                 camera = capture[1]
                
            if(self.path.endswith("cam3.mjpg")):
                camera = capture[2]

            while running:
                try:
                    rc, img = camera.read()
                    if not rc:
                        continue
                
                    imgRGB=cv2.cvtColor(img,cv2.COLOR_RGB2GRAY)
                    jpg = Image.fromarray(imgRGB)
                    r, buf = cv2.imencode(".jpg",imgRGB)
                    self.wfile.write("--jpgboundary")
                    self.send_header('Content-type','image/jpeg')
                    self.send_header('Content-length',str(len(buf)))
                    self.end_headers()
               
                    self.wfile.write(bytearray(buf))
                    self.wfile.write("\r\n")
                    time.sleep(0.05)

                except KeyboardInterrupt:
                    print("KEY EXCEPTION")
                    running = False
                    break
            
            print("Finished Thread")

            return

        if self.path.endswith('.html'):
            self.send_response(200)
            self.send_header('Content-type','text/html')
            self.end_headers()
            self.wfile.write('<html><head></head><body>')
            self.wfile.write("<h1>WEBCAM OUT</h1>")
            self.wfile.write('<img src="/cam1.mjpg"/>')
            self.wfile.write('<img src="/cam2.mjpg"/>')
            self.wfile.write('<img src="/cam3.mjpg"/>')
            self.wfile.write('</body></html>')
            return

class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
	"""Handle requests in a separate thread."""
def main():
    global capture
    capture = []
    capture.append(cv2.VideoCapture(0))
    capture.append(cv2.VideoCapture(1))
    capture.append(cv2.VideoCapture(2))

    try:
        server = ThreadedHTTPServer(('localhost', 8080), CamHandler)
        print("server started")
        server.serve_forever()
    except KeyboardInterrupt:
        for cam in capture:
            cam.release()
        server.socket.close()

    print("All done")

if __name__ == '__main__':
	main()