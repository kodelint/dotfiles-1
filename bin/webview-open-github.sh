#!/bin/bash
set -e

echo """ \
{ "app": "WebView", \
"arguments": { \
"url": $1 \
} \
}""" | base64

# printf "\x1b]1337;NativeView=CnsgImFwcCI6ICJXZWJWaWV3IiwKImFyZ3VtZW50cyI6IHsKInVybCI6ICJodHRwczovL2dpdGh1Yi5jb20vZ25hY2htYW4vaVRlcm0yIgp9Cn0=\x07"

# printf "\x1b]1337;NativeViewHeightAccepted=Webview, 200\x07"
