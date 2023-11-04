# Windows Installation ::::

# Step 1: $env:GOOGLE_APPLICATION_CREDENTIALS="C:\Users\daksh\Desktop\Pratyaksh\key.json"
# Step 2: Create a Virtual Environment :-
# 1. pip install virtualenv
# 2. python -m venv venv
# 3. venv\Scripts\activate
# Step 3: pip install --upgrade google-cloud-speech
# Step 4: gcloud init

# Linux Installation ::::

# Step 1: export GOOGLE_APPLICATION_CREDENTIALS="./key.json"
# Step 2: Create a Virtual Environment :-
# 1. pip install virtualenv
# 2. virtualenv venv
# 3. source venv/bin/activate
# Step 3: pip install --upgrade google-cloud-speech
# Step 4: gcloud init


# -------------------------------------------------->>
# New algorithm for display on OLED display



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
from PIL import ImageFont
from PIL import Image, ImageDraw, ImageFont



# Set Google Cloud credentials environment variable
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'key.json'

# Initialize the OLED display
serial = i2c(port=1, address=0x3C)
device = ssd1306(serial, width=128, height=64)

font = ImageFont.truetype("./Paul-le1V.ttf", 20)


def transcribe_audio_stream():
    client = speech.SpeechClient()

    streaming_config = speech.StreamingRecognitionConfig(
        config=speech.RecognitionConfig(
            encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
            sample_rate_hertz=14100,  # Adjust this based on your microphone
            language_code="en-IN",
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
                        
                            wrapped_lines=wrap(new_char,width=16)
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
    transcribe_audio_stream()
  
