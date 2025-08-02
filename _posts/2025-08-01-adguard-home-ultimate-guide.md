---
layout: post
title: "AdGuard Home Setup on Raspberry Pi: Block Ads & Trackers Network-Wide"
description: A practical guide to setting up AdGuard Home on a Raspberry Pi for network-wide ads and trackers blocking, with limitations, gotchas, and a comparison to Pi-hole.
tagline: Block ads and trackers across your entire network with AdGuard Home on a Raspberry Pi.
medium_url: https://medium.com/@LazyDom/adguard-home-setup-on-raspberry-pi-block-ads-trackers-network-wide-0b48b60786a2
cdn_base: "https://gist.githubusercontent.com/LazyDom/b419742c099e5eb6d98c769d1381eb82/raw/a1b55bdcef45f8caa9826d1b248e06082d554a91/"
author: LazyDom
date: 2025-08-01
---


**AdGuard Home** is a **free** :money_with_wings:, **open-source** solution that **blocks ads and trackers** :no_entry_sign: across your entire network. **No client software required** :no_mobile_phones:. Running on your own hardware (like a **Raspberry Pi**), it acts as a **DNS server** :globe_with_meridians:, rerouting unwanted domains to a “black hole” :black_circle: and protecting your **privacy** :lock: on every device. In this guide, you’ll learn how to **set up AdGuard Home** :hammer_and_wrench:, understand its **limitations** :warning: and gotchas, and see how it compares to **Pi-hole**.


I like to call it your personal **AdGuardian** :shield:—a digital shield for your home network.


<!--more-->

![AdGuard Home Agnar Mascot](https://cdn.adtidy.org/website/adguard.com/svg/agnar-top-line.svg)

# Why AdGuard Home?
*Already have your Pi set up? [Skip to Installing AdGuard Home](#2-install-adguard-home-on-raspberry-pi-os)* :fast_forward:

+ **Protects your privacy** and **blocks ads/trackers** for every device on your network—no client software needed. :lock:
+ **Free**, **open-source**, and easy to run on your own hardware. :rocket:
+ Works as a **DNS server**, rerouting unwanted domains to a “black hole” so your devices never connect to them. :no_entry_sign:
+ Built on the same technology as **AdGuard’s public DNS**, but fully under your control. :satellite:
+ **Supports a variety of platforms**—AdGuard Home can be installed on Raspberry Pi, Linux, macOS, Windows, and more. There are also add-ons for [**Home Assistant**](https://github.com/hassio-addons/addon-adguard-home) and an **OpenWrt app**. See the [official getting started guide](https://adguard-dns.io/kb/adguard-home/getting-started/) and the [other platforms section](https://adguard-dns.io/kb/adguard-home/getting-started/#other) for details. :computer:

![AdGuard Home Dashboard Overview GIF]({{ page.cdn_base }}raspi-zero-2-w-adguard-home-dash-overview.gif)
*AdGuard Home dashboard overview and features (animated)*

# Hardware & Prerequisites

*Already have your Pi set up? [Skip to Installing AdGuard Home](#2-install-adguard-home-on-raspberry-pi-os)* :fast_forward:

- Raspberry Pi (any model with network access)
> **Note:** In my case, I am using a [Raspberry Pi Zero 2 W H](https://amzn.to/4fgB7vi) (affiliate link). Any Raspberry Pi model with network access will work, but your experience may vary slightly depending on the hardware.
- [microSD card](https://amzn.to/4560f2Y) (affiliate link)

*See [Affiliate Link Disclosure](#affiliate-link-disclosure) below.*
- Power supply
- SSH access to Raspberry Pi
- Access to your router's DNS settings

![Raspberry Pi Zero 2 W H]({{ page.cdn_base }}rasp-pi-zero-2-w-h.jpg)
*Raspberry Pi Zero 2 W H — compact, affordable, and perfect for AdGuard Home projects*


# Installation Steps

*Jump to: [Enable DHCP Server](#optional-enable-and-configure-dhcp-server) | [Limitations & Gotchas](#limitations--gotchas) | [AdGuard Home vs. Pi-hole](#adguard-home-vs-pi-hole) | [Conclusion](#conclusion)*

## 1. Install Raspberry Pi OS

*If you’ve already installed Raspberry Pi OS, [jump to AdGuard Home installation](#2-install-adguard-home-on-raspberry-pi-os).* :arrow_right:

1. Flash the image to your microSD card using [Raspberry Pi Imager](https://www.raspberrypi.com/software/) (recommended):
   - Plug your microSD card into your laptop or computer using a card reader or built-in slot.
   - **Download and install [Raspberry Pi Imager](https://www.raspberrypi.com/software/)** if you haven't already.
   - **Open** the Raspberry Pi Imager application on your computer.
   - In Raspberry Pi Imager, **select your Raspberry Pi device**, **choose the OS** you want to install, and **select your microSD card** as the storage device.
   - **Click "Next"** to proceed.

   ![Raspberry Pi Imager - Device Selection]({{ page.cdn_base }}raspi-zero-2-w-imager-1.png)
   *Selecting your Raspberry Pi device in Raspberry Pi Imager*


   > :bulb: **Tip:** (Recommended) When prompted with "Would you like to apply OS customization settings?", **click the "EDIT SETTINGS" button** to pre-configure your Pi (hostname, username, Wi-Fi, locale, SSH etc.).


   > :zap: I call it a Lazy approach! Your Pi will automagically connect to Wi-Fi after successful flashing and will be ready for SSH access right away.


   ![Raspberry Pi Imager - OS Customization Prompt]({{ page.cdn_base }}raspi-zero-2-w-imager-2.png)
   *Choosing the Raspberry Pi OS Customization Prompt in Raspberry Pi Imager*

     - **Set the hostname**
     - **Set Username and Password**
     - **Add Wi-Fi credentials** (SSID, Password) and Country
     - **Set locale settings** (Time Zone)

   ![Raspberry Pi Imager - OS Customization - General]({{ page.cdn_base }}raspi-zero-2-w-imager-3.png)
   *OS Customization - General Settings in Raspberry Pi Imager*

     - Under the "Services" tab, **enable SSH for remote access** and then **click "SAVE"**

   ![Raspberry Pi Imager - OS Customization - Services]({{ page.cdn_base }}raspi-zero-2-w-imager-4.png)
   *OS Customization - Services Settings to enable SSH in Raspberry Pi Imager*

   - This makes your Pi ready to connect to your Wi-Fi network and be accessed via SSH immediately after first boot.
   - You will see a pop up saying "Would you like to apply OS customization settings?", then, **click the "YES" button** to write / start flashing the image to your microSD card.

   ![Raspberry Pi Imager - OS Customization - Apply]({{ page.cdn_base }}raspi-zero-2-w-imager-5.png)
   *OS Customization - Apply in Raspberry Pi Imager*

   - **Wait for the process to complete.** It typically takes 5 to 30 mins depending on your microSD card and laptop specs. For me, it took about 5 mins but your mileage may vary!

   ![Raspberry Pi Imager - Writing Workflow]({{ page.cdn_base }}raspi-zero-2-w-imager-6.gif)
   *Writing workflow in Raspberry Pi Imager (animated)*

   - After a successful write, you will see a pop-up prompting - **"Write Successful, You can now remove the microSD card from the reader"**
   ![Raspberry Pi Imager - Write Successful]({{ page.cdn_base }}raspi-zero-2-w-imager-7.png)
   *Write Successful: You can now remove the microSD card from the reader*   

2. Insert the microSD card into your Raspberry Pi and power it on.
3. If you used OS CUSTOMIZATION, your Pi will auto-connect to Wi-Fi (if set), use your chosen hostname, and have SSH enabled already and ready to ride thru the wild tunnels of SSH. Otherwise, **complete the initial setup** (locale, Wi-Fi, etc.) via the desktop or SSH.
4. (Optional but Recommended) **Update your system:** :arrow_up:
   ```sh
   sudo apt update && sudo apt upgrade -y
   ```

## 2. Install AdGuard Home on Raspberry Pi OS

*Need to set up DHCP? [Jump to DHCP Server instructions](#optional-enable-and-configure-dhcp-server).* 

1. Set a static IP address for your Pi **(Highly Recommended** :pushpin: **- since AdGuard Home is a server so it needs a static IP address to function properly. Otherwise, at some point your router may assign a different IP address to this device. Also, this step is mandatory if you plan to use [AdGuard Home as a DHCP server](#optional-enable-and-configure-dhcp-server))):**

   - **List available connections** (run the below command to get a list of connection names available to use):
     ```sh
     sudo nmcli con show
     ```

     ![nmcli con show output]({{ page.cdn_base }}raspi-zero-2-w-ssh-nmcli-con-show.png)                         
     *Output of 'nmcli con show' listing available network connections on Raspberry Pi*
   - **Display a summary of all network interfaces** (NICs, for both IPV4 and IPV6 addresses):
     ```sh
     ip a
     ```

     ![ip a output]({{ page.cdn_base }}raspi-zero-2-w-ssh-ip-a.png)
     *Output of 'ip a' showing network interfaces and IP addresses on Raspberry Pi*
     
   - **Set a static IP on Raspberry Pi** (run the below command to set a static IP for the existing wireless LAN connection with name as "Preconfigured"):
     ```sh
     sudo nmcli con mod "<your connection name>" ipv4.addresses "<192.168.x.x/24>" ipv4.gateway "<192.168.x.x>" ipv4.dns "<1.1.1.1>" ipv4.method manual
     ```

     ![nmcli set static IP output]({{ page.cdn_base }}raspi-zero-2-w-ssh-set-static-ip.png)
     *Setting a static IP address for a network connection on Raspberry Pi*

   - **Reboot the Raspberry Pi** to reflect the above change:
     ```sh
     sudo reboot
     ```
   - **Verify the static IP** on wlan0 interface to confirm the change:
     ```sh
     ip a
     ```

     ![ip a updated output]({{ page.cdn_base }}raspi-zero-2-w-ssh-ip-a-updated.png)
     *Output of 'ip a' showing updated static IP address on Raspberry Pi after reboot*

2. Download and run the AdGuard Home installer: :package:
   ```sh
   curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
   ```

   ![AdGuard Home install output]({{ page.cdn_base }}raspi-zero-2-w-ssh-adguard-home-install.png)
   *Running the AdGuard Home installer script on Raspberry Pi*
   - The above script also accepts some options: :wrench:
     - `-c <channel>` to use a specified channel
     - `-r` to **reinstall AdGuard Home**
     - `-u` to **uninstall AdGuard Home**
     - `-v` for **verbose output**
     > **Note:** Options `-r` and `-u` are mutually exclusive.

# Configuration & Usage

## Basic Configuration

1. **Access the AdGuard Home Web Interface:** :globe_with_meridians:
   - **Open a browser** :globe_with_meridians: and go to `http://<your-pi-ip>:3000` (replace `<your-pi-ip>` with your Raspberry Pi's IP address).
   - **Follow the initial setup wizard** :mag: if prompted:
      - **Set the admin interface username and password** for security.
      - **Change the Admin web interface port** to 80 if port 3000 is already in use.
      - **Adjust DNS server listening interfaces** if you want AdGuard Home to listen on specific network interfaces.
      - **Prompt:** Use a static IP address, since AdGuard Home is a server and needs a static IP to function properly. Otherwise, your router may assign a different IP address to this device. **Click "Next"** to continue.
      - **Set the admin interface username and password** for security to protect it from unrestricted access. **Click "Next"** to continue.
      - **Prompt:** Ensure your Raspberry Pi's IP address is set as the DNS server for your home network (usually in your router's DHCP/DNS settings). **Click "Next"** to continue.
      > **Note:** On many home routers like Netgear, TP-Link etc. operating in **"Router Mode"** you cannot set a custom DNS server under DHCP settings. In that case, setting up [AdGuard Home as a DHCP server](#optional-enable-and-configure-dhcp-server) will help.


   ![Netgear Nighthawk RS700 Router Wi-Fi 7]({{ page.cdn_base }}netgear-wifi-7-nighthawk-rs700-router.jpg)
*[Netgear Nighthawk RS700 Wi-Fi 7](https://amzn.to/4l6nsrV) (affiliate link) — example of a home router where custom DNS settings may be restricted in Router Mode* :warning:
   
   *See [Affiliate Link Disclosure](#affiliate-link-disclosure) below.*

  
   ![Netgear Router Admin Portal - DNS Not Editable]({{ page.cdn_base }}netgear-wifi-7-nighthawk-rs700-router-dns-no-edit.png)
   *Netgear Nighthawk RS700 admin portal: DNS server field is not available under DHCP settings in Router Mode* :warning:
   
      - Voila! You will be prompted with "Congratulations!" The setup procedure is complete and you're now ready to start using AdGuard Home. **Click "Open Dashboard"**. You will then be redirected to `http://<your-pi-ip>/login.html`
      > **Note:** Admin Web Interface is no longer available on port 3000 and instead is accessible on port 80.
   - **Enter your Username and Password** and then **click "Signin"**. Boom! :boom: You have now officially landed on the AdGuard Home Dashboard! WooHoo! :tada:

   ![AdGuard Home Initial Setup GIF]({{ page.cdn_base }}raspi-zero-2-w-adguard-home-initial-setup.gif)
   *AdGuard Home initial setup and dashboard walkthrough (animated)* :tada:

   ![AdGuard Home Dashboard Screenshot]({{ page.cdn_base }}raspi-zero-2-w-adguard-home-dash.png)
   *AdGuard Home dashboard — main view after login* :chart_with_upwards_trend:

2. **Set Up DNS:** :globe_with_meridians:
   - In the AdGuard Home dashboard, **go to Settings → DNS settings**.
   - **Add or remove upstream DNS servers** (e.g., Cloudflare, Google, Quad9) as needed.
   - (Optional) **Enable DNS-over-HTTPS or DNS-over-TLS** for encrypted DNS queries.
   - **Ensure your Raspberry Pi's IP address is set as the DNS server** for your home network (usually in your Home router's DHCP/DNS settings).

3. **General Settings:** :gear:
   - **Go to Settings → General settings.** Below are optional and are great additions to harden your DNS security:
      - **Enable Web Security** to check if a domain is blocked by browsing security web service. It will use a privacy-friendly lookup API to perform the check: only a short prefix of the domain name SHA256 hash is sent to the server.
      - **Enable Parental Control** to block adult websites and enforce safe browsing for kids.

      > :bulb: **Side Note:** An excellent example of this is when AdGuard Home :shield: is installed as a [Home Assistant Community Add-on](https://github.com/hassio-addons/addon-adguard-home) :house_with_garden:. In this setup, you can write automations in Home Assistant :robot: to turn on parental controls :no_entry_sign: when the kids get home :family: or based on any smart home trigger :bulb:.  
      > **But let's not go down that Rabbit Hole :rabbit2: here!** For the sake of this post, we'll stick with AdGuard Home running directly on your Raspberry Pi. If you're curious about Home Assistant automations, that's a whole new adventure for another day!

      - **Enable Safe Search** to enforce safe search in the following search engines:
         - :white_check_mark: Bing
         - :white_check_mark: Duckduckgo
         - :white_check_mark: Ecosia
         - :white_check_mark: Google
         - :white_check_mark: Pixabay
         - :white_check_mark: Yandex
         - :white_check_mark: Youtube
   - **Review and adjust other options** as desired, such as statistics collection (more on that later) or query logging.

   ![AdGuard Home General Settings]({{ page.cdn_base }}raspi-zero-2-w-adguard-home-general-settings.png)
   *AdGuard Home general settings section*
   - **Click Save** after making changes.

4. **Blocklists & Filters:** :no_entry_sign:
   - **Go to Filters → DNS blocklists.**
      - **Add or remove blocklists** as desired. The defaults are good for most users, but you can add more for stricter blocking. After making changes, **click Apply** to save.
   - **Go to Filters → Custom Filtering Rules.**
      - **Add or remove custom filtering rules.** It employs good old [regex syntax](https://github.com/AdguardTeam/AdGuardHome/wiki/Hosts-Blocklists), which allows for powerful and flexible matching. After making changes, **click Apply** to save.
      > **Note:** I can spend all day on just custom filtering rules and it's meant for advanced use cases. Don't be afraid by the [regex syntax](https://github.com/AdguardTeam/AdGuardHome/wiki/Hosts-Blocklists), just try it out and thank me later!
   - Your AdGuard Home instance is now ready to block ads and trackers for all devices using it as their DNS server!

   ![AdGuard Home Custom Filtering Rules]({{ page.cdn_base }}raspi-zero-2-w-adguard-home-custom-filters.png)
   *Custom Filtering Rules section in AdGuard Home*

5. **Logs and Statistics Retention:** :bar_chart:
   - Under **Settings → General settings → Logs configuration**, the default is set to 24 hours. This means the next day you might wake up to find your logs missing. So don't be surprised! **Consider increasing the log retention** to 7, 30, or 90 days, depending on your needs.
   - Under **Settings → General settings → Statistics configuration**, the default is set to 24 hours. **Consider increasing the statistics retention** to 7, 30, or 90 days, depending on your dashboard needs.

   ![AdGuard Home Log Configuration]({{ page.cdn_base }}raspi-zero-2-w-adguard-home-log-conf.png)
   *Log configuration options in AdGuard Home*

   ![AdGuard Home Statistics Retention]({{ page.cdn_base }}raspi-zero-2-w-adguard-home-stats-conf.png)
   *Statistics retention settings in AdGuard Home*

## (Optional) Enable and Configure DHCP Server

*Not sure why you need this? [See Limitations & Gotchas](#limitations--gotchas).* 

AdGuard Home can act as your network's DHCP server, which is useful if your router does not allow you to set a custom DNS server for clients.

**Before you begin:** :warning:
- Only enable the DHCP server in AdGuard Home if you disable the DHCP server on your router. Running two DHCP servers on the same network will cause conflicts!

**To enable DHCP in AdGuard Home:** :hammer:
1. Go to **Settings → DHCP settings** in the AdGuard Home dashboard.
2. **Toggle Enable DHCP server.**
3. **Set the IP address range** (start and end) for your network (e.g., `192.168.1.100` to `192.168.1.200`).
4. **Set the gateway IP address** (usually your router's IP, e.g., `192.168.1.1`).
5. **Set the subnet mask** (e.g., `255.255.255.0`).
6. **Click Save** to apply the settings.

![AdGuard Home DHCP Server Settings]({{ page.cdn_base }}raspi-zero-2-w-adguard-home-dhcp.png)
*DHCP server settings in AdGuard Home*

> **Note:** By default, AdGuard Home will use itself as [DNS server for the DHCP clients](https://github.com/AdguardTeam/AdGuardHome/wiki/DHCP#default-options). The default lease time is 24 hours.



**After enabling:** :white_check_mark:
- **Reboot or reconnect your devices** so they receive new IP addresses and DNS settings from AdGuard Home.
- **View and manage DHCP leases** in the same section.

> **Tip:** Using AdGuard Home as your DHCP server ensures all devices on your network use it for DNS, even if your router doesn't support custom DNS settings.



# Limitations & Gotchas

*Curious about alternatives? [See AdGuard Home vs. Pi-hole](#adguard-home-vs-pi-hole).* 

**Limitations:** :no_entry_sign:
Here are some examples of what cannot be blocked by a DNS-level blocker aka AdGuard Home:

- YouTube, Twitch ads;

- Facebook, Twitter, Instagram sponsored posts.

Essentially, any advertising that shares a domain with content cannot be blocked by a DNS-level blocker.
[Known Limitations](https://github.com/AdGuardTeam/AdGuardHome#known-limitations)

**Gotchas:** :exclamation:
- On many home routers like Netgear, TP-Link etc. operating in **"Router Mode"** you cannot set a custom DNS server under DHCP settings. In that case, you have two options to ensure all devices use AdGuard Home for DNS:
   1. **Use your home router in Access Point (AP) mode instead of Router mode.** This allows you to set a custom DNS server for your network clients, as the main router (often your ISP's device) will handle DHCP and routing.
   2. **Use the DHCP feature of AdGuard Home.** Disable DHCP on your router and enable it in AdGuard Home to control DNS assignment. See the section above for details on enabling [AdGuard Home's DHCP server](#optional-enable-and-configure-dhcp-server).


# AdGuard Home vs. Pi-hole


Both AdGuard Home and Pi-hole block ads and trackers using DNS sinkholing, and both allow you to customize blocklists. However, AdGuard Home provides several features out-of-the-box that Pi-hole requires extra setup or software for:

{% gist LazyDom/4cbd2c259f10a991aa67f9f60e3d0a28 %}

> **Note:** Some features can be added to Pi-hole with extra software or manual configuration, but AdGuard Home aims to make these easy for all users.

For the latest, see the [official comparison](https://github.com/AdguardTeam/AdGuardHome#how-does-adguard-home-compare-to-pi-hole).

# Conclusion


AdGuard Home on a Raspberry Pi is a powerful, privacy-focused solution for blocking ads and trackers across your entire network. With features like encrypted DNS, parental controls, and flexible filtering, it’s a great alternative to Pi-hole and works well for both beginners and advanced users.

For more details and advanced configuration, check out the [official AdGuard Home documentation](https://github.com/AdguardTeam/AdGuardHome/wiki).

Have questions, tips, or feedback? Leave a comment below or reach out. Your input helps make this guide better for everyone!


### Affiliate Link Disclosure


Some links in this guide are Amazon affiliate links. If you purchase through these links, I may earn a small commission at no extra cost to you. Thank you for supporting this guide and helping keep it free and up to date!
