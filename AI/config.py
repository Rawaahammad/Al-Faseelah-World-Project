import os
from dotenv import load_dotenv

load_dotenv()

# ElevenLabs
ELEVENLABS_API_KEY = os.getenv("ELEVENLABS_API_KEY", "")

ELEVENLABS_VOICE_AR_FEMALE = os.getenv("HABIBAH_VOICE_ID", "")
ELEVENLABS_VOICE_AR_MALE = os.getenv("OMAR_VOICE_ID", "")
ELEVENLABS_VOICE_EN_FEMALE = os.getenv("LULU_VOICE_ID", "")
ELEVENLABS_VOICE_EN_MALE = os.getenv("ENGLISH_MALE_VOICE_ID", "")

ELEVENLABS_VOICE_AR = ELEVENLABS_VOICE_AR_FEMALE
ELEVENLABS_VOICE_EN = ELEVENLABS_VOICE_EN_FEMALE
ELEVENLABS_VOICE_ID = ELEVENLABS_VOICE_AR_FEMALE

# Supabase
SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_KEY = os.getenv("SUPABASE_KEY", "")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY", "")

# Local model path
VOSK_MODEL_PATH = os.getenv(
    "VOSK_MODEL_PATH",
    "/home/pi/alfaseelah/vosk-model-ar-mgb2-0.4"
)

# GPIO
BUTTON_PINS = [17, 18, 27, 22, 23, 24]

DEFAULT_CHILD = {
    "name": "صديقي",
    "age": 5,
    "profile_id": "child_001"
}