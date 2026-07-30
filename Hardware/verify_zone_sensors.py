#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
from dotenv import load_dotenv
from supabase import create_client
from gpiozero import Button
import signal

load_dotenv()
sb = create_client(os.getenv("SUPABASE_URL"), os.getenv("SUPABASE_KEY"))

ZONE_KEY = "home"

r = sb.table("pieces").select("*, zones!inner(key)").eq("zones.key", ZONE_KEY).execute()
pieces = r.data

print(f"=== منطقة: {ZONE_KEY} — {len(pieces)} قطعة مسجلة ===")
pin_to_name = {}
seen_pins = {}
for p in pieces:
    pin = p.get("sensor_pin")
    label = f"{p['key']} ({p['name_ar']})"
    print(f"  {label}  ->  sensor_pin: {pin}")
    if pin is not None:
        if pin in seen_pins:
            print(f"    ⚠️ تضارب! GPIO{pin} مسجل أيضاً لـ {seen_pins[pin]}")
        seen_pins[pin] = label
        pin_to_name[pin] = label

active = {}
def on_trigger(pin):
    name = pin_to_name.get(pin, "⚠️ pin مش مسجل بالداتا بيس لهاي المنطقة")
    print(f"\n[TRIGGER] GPIO{pin}  ->  {name}")

for pin in pin_to_name.keys():
    try:
        b = Button(pin, pull_up=True, bounce_time=0.05)
        b.when_pressed = (lambda p=pin: on_trigger(p))
        active[pin] = b
    except Exception as e:
        print(f"⚠️ GPIO{pin} فشل: {e}")

print(f"\nجاهزة — راقبة {len(active)} pin. حطي المغناطيس على كل سنسور بمنطقة البيت.")
print("Ctrl+C للخروج.\n")
signal.pause()
