# Windows Installation

# Step 1:$env:GOOGLE_APPLICATION_CREDENTIALS="C:\Users\daksh\Desktop\Pratyaksh\key.json"
# Step 2: Create a Virtual Environment :-
# 1. pip install virtualenv
# 2. python -m venv venv
# 3. venv\Scripts\activate
# Step 3: pip install --upgrade google-cloud-speech
# Step 4: gcloud init

# -------------------------------------------------->>


import os
from google.cloud import speech


def transcribe_speech(audio_file_path, language_code="en-IN"):
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "key.json"
    client = speech.SpeechClient()

    with open(audio_file_path, "rb") as audio_file:
        content = audio_file.read()

    audio = speech.RecognitionAudio(content=content)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=16000,  # Adjust based on your audio file
        language_code=language_code,
    )

    response = client.recognize(config=config, audio=audio)

    for result in response.results:
        print("Transcript: {}".format(result.alternatives[0].transcript))


if __name__ == "__main__":
    audio_file_path = "test_1.wav"
    transcribe_speech(audio_file_path)
