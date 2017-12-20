# Nero10

- Another iOS little tweak, allows Dark mode & Translucent on apps globally. Support iOS 9, 10
- Forked from https://gitlab.com/martinpham/Nero10

### Install
Add Cydia repo http://nbear3.github.io/ and search Nero10

### Build & Run

Change IP & Port of your device's SSH in `Makefile`

<pre><code> make package

or

THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
make package install
</code></pre>
