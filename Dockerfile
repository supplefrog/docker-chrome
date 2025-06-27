FROM rockylinux:9

RUN dnf install -y epel-release wget

RUN tee /etc/yum.repos.d/google-chrome.repo <<EOF
[google-chrome]
name=google-chrome - 64bit
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF

RUN dnf install -y google-chrome-stable\ 
    dbus dbus-libs gtk3 xorg-x11-server-Xvfb\
    libXcomposite libXdamage libXrandr libXcursor libXext libXfixes \
    libXi libXtst libXScrnSaver mesa-libEGL mesa-libGL nss \
    alsa-lib alsa-plugins-pulseaudio pulseaudio \
    && dnf clean all

# Create non-root user for Chrome
RUN useradd -m chromeuser
USER chromeuser
WORKDIR /home/chromeuser

# Set entrypoint
CMD ["google-chrome-stable", "--no-sandbox", "--disable-gpu"]
