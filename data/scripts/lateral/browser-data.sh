# Browser Data Discovery
# Usage: load lateral/browser_data.sh

print_header "Lateral: Browser Data"

# Firefox
print_with_label "Searching for Firefox Profiles..."
find ~/.mozilla/firefox -name "logins.json" -o -name "key4.db" 2>/dev/null | print_with_label "Firefox Credentials DBs"
find ~/.mozilla/firefox -name "places.sqlite" 2>/dev/null | print_with_label "Firefox History DBs"
find ~/.mozilla/firefox -name "cookies.sqlite" 2>/dev/null | print_with_label "Firefox Cookies DBs"

# Chrome / Chromium
print_with_label "Searching for Chrome/Chromium Data..."
find ~/.config/google-chrome ~/.config/chromium -name "Login Data" 2>/dev/null | print_with_label "Chrome Login DBs"
find ~/.config/google-chrome ~/.config/chromium -name "History" 2>/dev/null | print_with_label "Chrome History DBs"
find ~/.config/google-chrome ~/.config/chromium -name "Cookies" 2>/dev/null | print_with_label "Chrome Cookies DBs"

print_with_label "Note: These files are usually locked if the browser is open."
print_with_label "Exfiltrate these files to decrypt offline."
