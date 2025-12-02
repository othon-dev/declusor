#!/bin/bash
# -----------------------------------------------------------------------------
# Locates Firefox and Chrome/Chromium profile data (logins, history, cookies)
# for offline decryption and analysis.
# -----------------------------------------------------------------------------

# Firefox
find ~/.mozilla/firefox -name "logins.json" -o -name "key4.db" 2>/dev/null
find ~/.mozilla/firefox -name "places.sqlite" 2>/dev/null
find ~/.mozilla/firefox -name "cookies.sqlite" 2>/dev/null

# Chrome / Chromium
find ~/.config/google-chrome ~/.config/chromium -name "Login Data" 2>/dev/null
find ~/.config/google-chrome ~/.config/chromium -name "History" 2>/dev/null
find ~/.config/google-chrome ~/.config/chromium -name "Cookies" 2>/dev/null
