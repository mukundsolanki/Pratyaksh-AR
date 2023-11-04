#source venv/bin/activate


import os
import time
import pyaudio

import difflib
import textwrap
from luma.core.interface.serial import i2c
from luma.core.render import canvas
from luma.oled.device import ssd1306
from textwrap import wrap
from google.cloud import speech_v1p1beta1 as speech
from websockets import serve
import asyncio
import threading
from PIL import ImageFont
from PIL import Image, ImageDraw, ImageFont



# Set Google Cloud credentials environment variable
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'key.json'

# Initialize the OLED display
serial = i2c(port=1, address=0x3C)
device = ssd1306(serial, width=128, height=64)

font = ImageFont.truetype("./Paul-le1V.ttf", 20)


def transcribe_audio_stream(lang):
    client = speech.SpeechClient()

    streaming_config = speech.StreamingRecognitionConfig(
        config=speech.RecognitionConfig(
            encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
            sample_rate_hertz=14100,  # Adjust this based on your microphone
            language_code=lang,
            model="default",
        ),
        interim_results=True,
    )

    current_transcript = []  # Initialize the current transcript as an empty list

    current_len=0
    with MicrophoneStream(sampling_rate=14100, chunk_size=1024) as stream:
        audio_generator = stream.generator()
        requests = (speech.StreamingRecognizeRequest(audio_content=content) for content in audio_generator)

        for response in client.streaming_recognize(config=streaming_config, requests=requests):
            for result in response.results:
                new_transcript = result.alternatives[0].transcript
                words = new_transcript.split()
                new_char=" ".join(words) 
                if(result.is_final):
                    current_len=0
                    new_char=" "
                    #time.sleep(1)
                    draw.rectangle(device.bounding_box, outline="black", fill="black")
                    print("\033[K\r",end='')
                else:
                    if(len(new_char)>current_len and result.stability>0.3):
                        current_len=len(new_char)
                        print("\033[K\rTranscript: {}".format(new_char), end='', flush=True)
                        with canvas(device) as draw:
                        
                            wrapped_lines=wrap(new_char,width=13)
                            y=4
                            for line in wrapped_lines:
                                if(y+12>45):
                                    y=4
                                    draw.rectangle(device.bounding_box, outline="black", fill="black")
                                    draw.text((4,y),line,fill="white", font=font)
                                    y+=13
                                else:
                                    draw.text((4,y),line,fill="white", font=font)
                                    y+=12
              
                            
                
                            
                            
async def websocket_server(websocket, path):
    while True:
        try:
            data = await websocket.recv()
            print(f"Received data: {data}")
            received_data.append(data)  # Store the received JSON data in the received_data list
        except websockets.exceptions.ConnectionClosedOK:
            break



class MicrophoneStream:
    def __init__(self, sampling_rate, chunk_size):
        self._audio_interface = pyaudio.PyAudio()
        self._audio_stream = self._audio_interface.open(
            format=pyaudio.paInt16,
            channels=1,
            rate=sampling_rate,
            input=True,
            frames_per_buffer=chunk_size,
        )
        self._generator = self.generate_chunks()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self._audio_stream.stop_stream()
        self._audio_stream.close()

    def generate_chunks(self):
        while True:
            yield self._audio_stream.read(1024)

    def generator(self):
        for chunk in self._generator:
            yield chunk

if __name__ == "__main__":
    lang1="en-US"
    lang2="en-IN"
    lang3="hi-IN"
    lang4="mi-IN"
    transcription_thread = threading.Thread(target=transcribe_audio_stream(lang2))
  # Allow the thread to exit when the main program exits
    transcription_thread.start()
    asyncio.get_event_loop().run_until_complete(serve(websocket_server, '0.0.0.0', 8765))
