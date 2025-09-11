# Firebase Authentication with Toit

Below an application in the __Toit__ programming language that demonstrates adding records to the __Firebase Realtime Database__ using authentication via generated __ID Token__ (JWT).

## Introduction

The application uses the approach described earlier in the project https://github.com/mk590901/toit-rest-api-db, namely adding data to the cloud DB using __posting__. However, unlike the previous version, the current one uses the __Firebase authentication__ system. That is, this version of the application provides a more secure way to transfer and save data.

## Brief description


## Implementation

## Preparation of Firebase Realtime Database via Firebase Console

> Get API Key

* Select your project.
* Go to __Project Settings__ (gear icon in the upper left corner ➜ __Project settings__).
* In the __General tab__, scroll down to the apps section.
* If you don't have an app registered, add a web (or Android) app.
* Click __Add app__ ➜ select a web app (icon </>).
* Register your app and extract the __API__ Key from the configuration.

> Set up security rules

* To use the __API key__, set up security rules in Firebase Realtime Database (in the Realtime Database ➜ Rules section). Example of rules allowing access with an API key:
```
{
  "rules": {
    "users": {
      ".read": "auth != null",
      ".write": "auth != null"
    }
  }
}
```
> To use __Firebase Authentication__ to generate an ID Token (JWT), you need to enable authentication for __Firebase Realtime Database__ settings:
* In the __Firebase Console__, go to __Authentication__ ➜ Sign-in method.
* Enable at least one sign-in method, such as __Anonymous__ (for simplicity) or __Email/Password__. In this case, __Anonymous__ is selected.

## Application management

> Installing packages:

* __http__
```
$ jag pkg install github.com/toitlang/pkg-http@v2
```
* __certificate-roots__
```
$ jag pkg install github.com/toitware/toit-cert-roots@v1
```

> Loading the application

```
micrcx@micrcx-desktop:~/toit/person$ jag run -d midi users.toit
Scanning for device with name: 'midi'
Running 'users.toit' on 'midi' ...
Success: Sent 119KB code to 'midi' in 3.35s
micrcx@micrcx-desktop:~/toit/person$ 
```

> Monitoring
```
micrcx@micrcx-desktop:~/toit/person$ jag monitor -p /dev/ttyACM1
Starting serial monitor of port '/dev/ttyACM1' ...
ESP-ROM:esp32s3-20210327
Build:Mar 27 2021
rst:0x15 (USB_UART_CHIP_RESET),boot:0x8 (SPI_FAST_FLASH_BOOT)
Saved PC:0x40385b12
SPIWP:0xee
mode:DIO, clock div:1
load:0x3fce2810,len:0xdc
load:0x403c8700,len:0x4
load:0x403c8704,len:0xa08
load:0x403cb700,len:0x257c
entry 0x403c8854
[toit] INFO: starting <v2.0.0-alpha.184>
[toit] DEBUG: clearing RTC memory: powered on by hardware source
[toit] INFO: running on ESP32S3 - revision 0.2
[toit] INFO: using SPIRAM for heap metadata and heap
[wifi] DEBUG: connecting
E (4007) wifi:Association refused too many times, max allowed 1
[wifi] WARN: connect failed {reason: unknown reason (208)}
[wifi] DEBUG: closing
[jaguar] WARN: running Jaguar failed due to 'CONNECT_FAILED: unknown reason (208)' (1/3)
[wifi] DEBUG: connecting
E (6777) wifi:Association refused too many times, max allowed 1
[wifi] WARN: connect failed {reason: unknown reason (208)}
[wifi] DEBUG: closing
[jaguar] WARN: running Jaguar failed due to 'CONNECT_FAILED: unknown reason (208)' (2/3)
[wifi] DEBUG: connecting
[wifi] DEBUG: connected
[wifi] INFO: network address dynamically assigned through dhcp {ip: 192.168.1.147}
[wifi] INFO: dns server address dynamically assigned through dhcp {ip: [192.168.1.1]}
[jaguar.http] INFO: running Jaguar device 'midi' (id: '1429cbbc-ca45-4c11-88ee-9500a1c318dc') on 'http://192.168.1.147:9000'
[jaguar] INFO: program 322d4e71-e169-757b-c0e7-fdbceb243d48 started
Obtaining ID Token and Refresh Token ...
Tokens successfully received
*** id_token->
eyJhbGciOiJSUzI1NiIsImtpZCI6ImUzZWU3ZTAyOGUzODg1YTM0NWNlMDcwNTVmODQ2ODYyMjU1YTcwNDYiLCJ0eXAiOiJKV1QifQ.eyJwcm92aWRlcl9pZCI6ImFub255bW91cyIsImlzcyI6Imh0dHBzOi8vc2VjdXJldG9rZW4uZ29vZ2xlLmNvbS9hdXRoLTJiN2QzIiwiYXVkIjoiYXV0aC0yYjdkMyIsImF1dGhfdGltZSI6MTc1NzUwNDA3NSwidXNlcl9pZCI6Ik95dnRQTWRHa2RVUWZPU1l0aW9GN1FnOVlMTzIiLCJzdWIiOiJPeXZ0UE1kR2tkVVFmT1NZdGlvRjdRZzlZTE8yIiwiaWF0IjoxNzU3NTA0MDc1LCJleHAiOjE3NTc1MDc2NzUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnt9LCJzaWduX2luX3Byb3ZpZGVyIjoiYW5vbnltb3VzIn19.Py_BNzkcqh0hkfY3ZCXq8KTk9IyjXAXx6vH4aEcmNKActR3CLWA9HE7rcLOV2mYLbh9d5JKZ7s2V7sBjAcD0Da6E6BajpL7cxbEA2EFAELb_-w2wct1kGz0J0NIAVDFDg4-AA-QR6IWM8jkYOisGLX5L-X8DtT8yq_-yVSBWD_7OWvucscEjYL2uFAeEHMBtz-bmEq5HcH7jOwZJBWC2ijLV4FVwO59_edFK5H8z5eEs6I9SvDMloMc_BY3Afg2GlFj47ADoAFHUEt9UAWkETdcqcxlKGCuYgPnelU1QyykKJVTjV5m2UXbXFVP1ro-fBdqr1EKo_WuoaZXGnq3E3w
*** refresh_token->
AMf-vBzNzokHLNP5eq1Xz6I-tlVqpfYaowXOP82CmmysS8rzG3aUN6v47ZBJ8tolQExfO74HFmBHCZ5L71RW2dFkLys9xVqWJDmctYMpz5_ymMt1nWCBG5F_0peQrV9e3Wh3x0UR8vedLtbn03EcfejsVRUuLBDTiowCSML4L_Z6wMuvOzxhI5o
Sending a POST request to https://auth-2b7d3-default-rtdb.firebaseio.com/users.json
User was created {name: -OZnOzkVaPFkgWO1vC6A}
Sending a POST request to https://auth-2b7d3-default-rtdb.firebaseio.com/users.json
User was created {name: -OZnP-44o5sHZX2xqlE0}
Sending a POST request to https://auth-2b7d3-default-rtdb.firebaseio.com/users.json
User was created {name: -OZnP-QCNogGEv8m7NSR}
[jaguar] INFO: program 322d4e71-e169-757b-c0e7-fdbceb243d48 stopped

```

## Movie

[users2.webm](https://github.com/user-attachments/assets/c20f33bd-f3dc-43e6-a6b4-a432512a929e)


