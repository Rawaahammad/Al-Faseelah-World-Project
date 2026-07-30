#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# zone_pin_mapper.py — تحقق وتخزين فوري، منطقة بمنطقة
import os
from dotenv import load_dotenv
from supabase import create_client
from gpiozero import Button
import signal, sys

load_dotenv()
sb = create_client(os.getenv("SUPABASE_URL"), os.getenv("SUPABASE_KEY"))

ZONE_KEY = "school"   # عدّليها لكل منطقة: home / mosque / school / zoo / careers

def get_zone_pieces(zone_key):
    r = sb.table("pieces").select("*, zones!inner(key)") \
        .eq("zones.key", zone_key).execute()
    return r.data

pieces = get_zone_pieces(ZONE_KEY)
if not pieces:
    print(f"ما في قطع مسجلة لمنطقة '{ZONE_KEY}' — تأكدي من الـ key الصح.")
    sys.exit(1)

print(f"=== منطقة: {ZONE_KEY} — {len(pieces)} قطعة متوقعة ===")
for p in pieces:
    status = f"pin={p.get('sensor_pin')}" if p.get('sensor_pin') is not None else "بدون pin بعد"
    print(f"  - {p['key']} ({p.get('name_ar','')}) [{status}]")

# راقبي كل الـ GPIO المحتملة (BCM numbering) — أي pin فاضي بالبورد
CANDIDATE_PINS = list(range(2, 28))
active = {}

def on_trigger(pin):
    print(f"\n[TRIGGER] GPIO{pin} انضغط.")
    print("أي قطعة من القائمة فوق؟ اكتبي الـ key (أو 's' لتخطي):")
    key = input("> ").strip()
    if key.lower() == 's':
        return
    match = next((p for p in pieces if p['key'] == key), None)
    if not match:
        print("مش موجودة بقائمة هاي المنطقة، تأكدي من الـ key.")
        return
    sb.table("pieces").update({"sensor_pin": pin}).eq("id", match["id"]).execute()
    print(f"✅ اتخزن فوراً: {key} -> GPIO{pin}")

for pin in CANDIDATE_PINS:
    try:
        b = Button(pin, pull_up=True, bounce_time=0.05)
        b.when_pressed = (lambda p=pin: on_trigger(p))
        active[pin] = b
    except Exception:
        pass  # pin مستخدم لغرض تاني أو معطوب، تجاهليه

print(f"\nجاهزة. حطي المغناطيس على كل سنسور بمنطقة {ZONE_KEY} وحدة وحدة.")
print("اضغطي Ctrl+C لما تخلصي هاي المنطقة.\n")
signal.pause()
