# Windows Installation

# Step 1:$env:GOOGLE_APPLICATION_CREDENTIALS="C:\Users\daksh\Desktop\Pratyaksh\key.json"
# Step 2: Create a Virtual Environment :-
# 1. pip install virtualenv
# 2. python -m venv venv
# 3. venv\Scripts\activate
# Step 3: pip install --upgrade google-cloud-speech
# Step 4: gcloud init

# -------------------------------------------------->>

import io
import os
from google.cloud import speech_v1p1beta1 as speech
import pyaudio
import difflib

# Set Google Cloud credentials environment variable
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'key.json'


def transcribe_audio_stream():
    client = speech.SpeechClient()

    streaming_config = speech.StreamingRecognitionConfig(
        config=speech.RecognitionConfig(
            encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
            sample_rate_hertz=14100,  # Adjust this based on your microphone
            language_code="en-US",
            enable_automatic_punctuation=True,
        ),
        interim_results=True,
    )

    current_transcript = []  # Initialize the current transcript as an empty list

    with MicrophoneStream(sampling_rate=16000, chunk_size=1024) as stream:
        
        audio_generator = stream.generator()
        requests = (speech.StreamingRecognizeRequest(audio_content=content) for content in audio_generator)
        responses = client.streaming_recognize(config=streaming_config, requests=requests)

        for response in responses:
            for result in response.results:
                new_transcript = result.alternatives[0].transcript
                words = new_transcript.split()
                # check the difference between current_transcript and result received
                diff = difflib.unified_diff(current_transcript, words, lineterm='', fromfile='current', tofile='new')
                diff = list(diff)

                # If major difference then add
                if (len(diff) > 2 ):  # Check if there are more than two lines of differences
                    current_transcript = words
                
                # \033 will clear the output lines and print the latest line to avoid printing the same words over and over
                print("\033[K\rTranscript: {}".format(" ".join(current_transcript)), end='', flush=True)





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