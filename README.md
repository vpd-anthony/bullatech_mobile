# App Setup & Usage Guide

## **Requirements**
- [Android Studio](https://developer.android.com/studio)  
- [Flutter SDK 3.13.9](https://docs.flutter.dev/get-started/install)  

---

## **Installation**
1. Clone this repository:
   ```bash
   git clone <repo-url>
   cd <repo-folder>
   ```
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. To generate files start build runner in watch mode:
   ```bash
   dart run build_runner watch -d
   ```

---

## **Connecting to Your Phone Wirelessly**

⚠ **Important:** Before enabling wireless debugging, you must:
1. Enable **Developer Options** on your phone.  
2. Enable **USB (wired) debugging** and connect your phone to your computer via USB.  
This initial wired connection is required to authorize your computer for debugging.

---

### **1. Enable Developer Options**
- On your phone, go to **Settings → About Phone**.
- Tap **Build Number** until you see the message *"You are now a developer!"*.

---

### **2. Enable USB Debugging**
- Go to **Settings → Developer Options → USB Debugging** → **Enable**.
- Connect your phone to your computer with a USB cable.
- On your phone, confirm the authorization prompt when it appears.

---

### **3. Enable Wireless Debugging**
- While still connected via USB, go to **Settings → Developer Options → Wireless Debugging** → **Enable**.

---

### **4. Switch ADB to TCP/IP Mode**
> Keep your phone connected via USB for this step.

#### **If you have only one device connected:**
```bash
adb tcpip 5555
```

#### **If you have multiple devices connected:**
```bash
adb -s <device_name> tcpip 5555
```

---

### **5. Find Your Phone's IP Address**
- On your phone, go to **Settings → About Phone → Status → IP address**.

---

### **6. Connect Wirelessly**
```bash
adb connect <phone_ip_address>
```

✅ **Tip:** If the phone’s IP address fails to connect:  
- Try connecting both your phone and computer to the **same Wi-Fi network**.  
- If that still doesn’t work, turn on your computer **Mobile hotspot** and connect your phone to it. Then repeat the `adb connect` step using the phone’s hotspot IP.

---

## **Running the App**
Run on the connected phone:
```bash
flutter run
```
