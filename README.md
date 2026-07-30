<div align="center">

<img src="assets/logo.svg" alt="Alfaseelah Logo" width="200"/>

# 🌱 Alfaseelah | الفسيلة

### An AI-Powered Interactive Educational Toy for Children

*Where physical play meets conversational intelligence — built on Raspberry Pi 5*

[![Made with Flutter](https://img.shields.io/badge/App-Flutter-02569B?logo=flutter&logoColor=white)](./Application)
[![Powered by Raspberry Pi](https://img.shields.io/badge/Hardware-Raspberry%20Pi%205-C51A4A?logo=raspberrypi&logoColor=white)](./Hardware)
[![AI Engine](https://img.shields.io/badge/AI-Gemini%20%2B%20Whisper-4285F4?logo=googlegemini&logoColor=white)](./AI)
[![Backend](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase&logoColor=white)](#-system-architecture)
[![Status](https://img.shields.io/badge/Status-Graduation%20Project-2E7D5B)]()

<br/>

**[Explore the Hardware](./Hardware) · [Explore the AI Engine](./AI) · [Explore the App](./Application) · [Documentation](./Documentation)**

</div>

---

## 📖 About the Project

**Alfaseelah** (الفسيلة — "the sapling") is a graduation project reimagining the educational toy: a physical, tactile play set that *listens, understands, and responds*. A child places a piece on a themed board — **school**, **home**, **mosque**, or **zoo/careers** — and Alfaseelah recognizes it, speaks about it in character, and reacts with a matching facial expression, all within a few seconds.

Meanwhile, a companion mobile app — **Pearant** — lets parents follow along: which child is playing, what they've learned, and what they've achieved.

> Built as a graduation project for the Electrical and Computer Engineering Department, Birzeit University.

---

## 🧩 System Architecture — Three Layers

<div align="center">

```
        🧒 Child places a piece on a board
                      │
                      ▼
        ┌─────────────────────────────┐
        │   1️⃣  HARDWARE LAYER         │
        │   Reed switches + GPIO       │
        │   on Raspberry Pi 5          │
        └───────────────┬─────────────┘
                         ▼
        ┌─────────────────────────────┐
        │   2️⃣  AI ENGINE LAYER        │
        │   Persona · Content Manager  │
        │   Whisper (STT) → Gemini     │
        │   → Voice + Pygame Face      │
        └───────────────┬─────────────┘
                         ▼
        ┌─────────────────────────────┐
        │   3️⃣  APPLICATION LAYER      │
        │   Pearant (Flutter)          │
        │   RFID login · Achievements  │
        │   Supabase (shared backend)  │
        └─────────────────────────────┘
```

</div>

### 1️⃣ Hardware Layer — [`/Hardware`](./Hardware)
The physical foundation. A grid of reed switch sensors wired zone-by-zone (school, home, mosque, and a shared zoo/careers board) into a Raspberry Pi 5's GPIO pins, with dynamic dual-zone mapping so the same pins can serve two boards.

### 2️⃣ AI Engine Layer — [`/AI`](./AI)
The brain and voice. A **Persona Module** shapes how Alfaseelah "speaks," a **Content Manager** pulls the right content for each piece, and a full voice pipeline — **Whisper** for speech-to-text and **Gemini** for response generation — completes a full interaction cycle in roughly **2–3.5 seconds**, paired with **Pygame**-rendered facial expressions.

### 3️⃣ Application Layer — [`/Application`](./Application)
The parent's window in. A **Flutter** app called **Pearant**, with RFID-based child identification, a live content library, an achievements screen, per-child preferences, and RLS-secured saved content — all synced through a shared **Supabase** backend.

---

## ✨ Features

| | Feature | Description |
|---|---|---|
| 🧠 | **Conversational AI Companion** | Persona-driven responses with real-time facial expressions |
| 🗺️ | **Multiple Learning Zones** | School, home, mosque, and a dynamic zoo/careers board |
| 🎙️ | **Fast Voice Interaction** | ~2–3.5s full cycle: listen → think → respond |
| 🪪 | **RFID Child Recognition** | The app knows exactly who's playing |
| 🏆 | **Achievements & Progress** | Kids unlock achievements; parents track progress |
| ⚙️ | **Live, Synced Content** | One Supabase backend drives both the toy and the app |
| 🔒 | **Secured Per-Child Data** | Row-Level Security on saved content and preferences |

---

## 🖼️ Gallery

<div align="center">

| Hardware Setup | AI in Action | Pearant App |
|:---:|:---:|:---:|
| *add photo here* | *add photo/gif here* | *add screenshot here* |

</div>

> 📌 Add your real photos/screenshots to `assets/` and swap the placeholders above — this section is what makes the repo feel alive, so don't skip it.

---

## 🛠️ Tech Stack

`Python` · `Raspberry Pi 5 (GPIO)` · `Flutter` · `Dart` · `Supabase (PostgreSQL)` · `OpenAI Whisper` · `Google Gemini` · `Pygame`

---

## 📂 Repository Structure

```
Al-Faseelah-World-Project/
├── Hardware/         # Sensors, GPIO mapping, wiring
├── AI/                # Persona, content manager, voice pipeline
├── Application/       # Pearant — Flutter parent app
├── Documentation/      # Report, diagrams, design docs
├── assets/             # Logo, images, media
└── README.md
```

---

## 👥 Team

<div align="center">

| Photo | Name | Role |
|:---:|:---:|:---:|
| 🧑‍💻 | **Rawaa** | *[role — e.g. AI & Hardware Integration]* |
| 🧑‍💻 | *[teammate name]* | *[role]* |
| 🧑‍🏫 | *[supervisor name]* | *Project Supervisor* |

</div>

> Electrical and Computer Engineering Department, Birzeit University

---

<div align="center">

*Made with 🌱 by the Alfaseelah team*

</div>
