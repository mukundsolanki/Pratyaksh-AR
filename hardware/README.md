
# Pratyaksh Hardware

This is a brief guide to Pratyaksh's hardware and the code that's required to run it.




## Connect 0.96' OLED display with Raspberry Pi Zero



![Diagram](https://github.com/mukundsolanki/HackCBS-Pratyaksh-AR/assets/97655058/0719e70c-3c84-45e7-984e-b71b752dab4e)

## GPIO Connection

```bash
    Display ---> PI

    VCC  ---> 5V GPIO
    GND  ---> GND
    SDA  ---> GPIO2
    SCL  ---> GPIO3
```
    
## Configure PI CODEC

To set the default inupt of Raspberry PI to the PI HAT/CODEC run the set_hat_default.py file after following code:

```bash
chmod +x set_audio_hat.py
sudo ./set_audio_hat.py
```


## Setup Google Cloud CLI tool for Windows

```bash
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\Users\daksh\Desktop\Pratyaksh\key.json"
pip install virtualenv
python -m venv venv
venv\Scripts\activate
pip install --upgrade google-cloud-speech
gcloud init
```
## Setup Google Cloud CLI tool for Linux

```bash
export GOOGLE_APPLICATION_CREDENTIALS="./key.json"
pip install virtualenv
virtualenv venv
source venv/bin/activate
pip install --upgrade google-cloud-speech
gcloud init
```

## How to run the code
Get into venv and type:

```
python speech_recognition.py
```


## Authors

- [@Daksh Kitukale](https://github.com/K-Daksh)
- [@Mukund Solanki](https://github.com/mukundsolanki)
- [@Gyaneshwar Choudhary](https://github.com/gyaneshwarchoudhary)

