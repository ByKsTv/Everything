import qrcode  # type: ignore


def generate_wifi_qr(ssid, password, security="WPA"):
    wifi_config = f"WIFI:T:{security};S:{ssid};P:{password};;"
    qr = qrcode.make(wifi_config)
    qr.save("WiFi QR Code.png")
    print("QR code saved as 'WiFi QR Code.png'")


# Change your Wi-Fi info here manually:
ssid = "WiFi_Name"
password = "WiFi_Password"
generate_wifi_qr(ssid, password)
