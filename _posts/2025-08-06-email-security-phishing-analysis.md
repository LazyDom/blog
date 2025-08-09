---
layout: post
title: "Email Security: How to Spot and Analyze Phishing Attacks"
categories: [security, email, phishing, analysis]
description: A practical guide to understanding, detecting, and analyzing phishing emails using real-world techniques and tools.
tagline: Strengthen your defenses—spot phishing before it strikes!
medium_url: 
author: LazyDom
date: 2025-08-08
---

### Why Email Security Matters

Most organizations rely on email as their primary means of communication, making it a major attack channel with significant financial risk.

## Email Security: How to Spot and Analyze Phishing Attacks

Common Email Threats:
- **Phishing**: Trick users into clicking malicious links or attachments
- **Spear Phishing**: Targeted attacks on individuals or organizations
- **Business Email Compromise (BEC)**: Impersonation of trusted contacts
- **Account Takeover (ATO)**: Using real accounts for further attacks
- **Malicious Attachments/Malware**: Files that deliver malware
- **Quishing & Emerging Attacks**: QR code phishing, AI-generated emails, calendar invites

Phishing emails use tricky phrases like “you have won a gift,” “don’t miss out on the big discount,” or “your account will be suspended if you don’t click.” The goal isn’t just to steal passwords, but to exploit the human factor—the weakest link in security. Attackers use phishing as a first step to infiltrate systems. :envelope: :warning: :mag:
Email is often the first point in the kill chain—defending it is critical.
<!--more-->

### Information Gathering & Spoofing

Because emails don’t always have authentication, attackers can send messages pretending to be someone else. Spoofing tricks users into trusting fake emails. Protocols like SPF, DKIM, and DMARC help verify senders, but aren’t always enforced. :busts_in_silhouette: :lock:

- **SPF** (Sender Policy Framework)
- **DKIM** (DomainKeys Identified Mail)
- **DMARC** (Domain-based Message Authentication, Reporting & Conformance)

To check if an email is spoofed, use tools like [MXToolbox](https://mxtoolbox.com/) to compare SPF, DKIM, DMARC, and MX records. Also, check the SMTP IP address with Whois records.

> Even if the sender isn’t spoofed, in other words SPF/DKIM/DMARC checks passed, hacked accounts can send malicious emails. Always be cautious!

---

### Email Traffic Analysis

Analyzing phishing attacks involves checking sender addresses, SMTP IPs, domains, subjects, recipients, and timestamps. If malicious emails target the same users repeatedly, their addresses may be leaked online (e.g., PasteBin). :clipboard: :detective:

Attackers can harvest emails using tools like Harvester on Kali Linux. Avoid posting personal emails publicly!

If emails arrive outside of office hours, the attacker may be in a different time zone—another clue to the attack’s nature.

---

## What is an Email Header & How to Read It?

The header contains sender, recipient, date, and routing info. Key fields include:

- **From:** Sender’s name/email
- **To:** Recipient’s name/email (plus CC/BCC)
- **Date:** When the email was sent
- **Subject:** Topic of the email
- **Return-Path:** Where replies go
- **Message-ID:** Unique email identifier
- **Received:** List of mail servers the email passed through
- **X-Spam Status:** Spam score and classification

To access headers:
- **Gmail:** Open email → 3 dots → Download message (.eml)
- **Outlook:** Open email → File → Info → Properties → Internet headers

---

## Email Header Analysis

When you suspect phishing, ask:
- Was the email sent from the correct SMTP server?
- Are the “From” and “Return-Path/Reply-To” fields the same?

Use [MXToolbox](https://mxtoolbox.com/) to check the domain’s MX servers. If the sender’s SMTP IP doesn’t match, it’s likely spoofed.

Compare “From” and “Reply-To”—if they differ, be suspicious. But always consider the full context (attachments, URLs, content).
- New domains in emails are often used for phishing.
- Trace email hops and analyze headers:
    - Start from the bottom of the header (closest to To/From)
    - Examine each "Received" line for mail server, IP, and domain

---

## Static Analysis

HTML emails can hide malicious links behind buttons or text. Always hover to check the real URL. :link: :eyes:

- Use [VirusTotal](https://www.virustotal.com/) to check URLs/files for malicious activity.

> Hash search preferred over file upload to avoid tipping off attackers.

> Check the scan date—old results may not reflect current threats.

**Caution:** Uploading files to VirusTotal can leak sensitive data—prefer hash lookups when possible.
- Use [Cisco Talos Intelligence](https://talosintelligence.com/) and [AbuseIPDB](https://abuseipdb.com/) to check SMTP IP reputation.

---

## Dynamic Analysis

Never run suspicious files on your own computer! Use sandbox environments like:

- [VMRay](https://www.vmray.com/)
- [JoeSandbox](https://www.joesandbox.com/)
- [AnyRun](https://any.run/)
- [Hybrid Analysis](https://www.hybrid-analysis.com/)

Online browsers like [Browserling](https://www.browserling.com/) (safe online browsing) let you safely check URLs. Always sanitize personal info before visiting suspicious sites.

> Malware may delay its actions to evade detection—be patient during analysis.

> Also, the fact that there are no URLs and files in the email does not mean that it is not malicious. The attacker may also send the malware as an image to avoid detection by the analysis tools.

---

## Additional Techniques

Attackers may use legitimate services to bypass filters:
- **Cloud storage links** (Google Drive, Microsoft OneDrive)
- **Free subdomains** (WordPress, Blogspot, Wix)
- **Form apps** (Google Forms)

These can trick users and analysts by appearing harmless.

### SOC Analyst Workflow: How Investigations Happen
SOC analyst's workflow for investigating suspicious emails:

1. **Monitoring & Detection**: Analysts use email gateways, EDR/XDR, SIEM, and user reports to monitor alerts.
2. **Triage**: Examine headers, links, attachments, sender behavior. Decide if the email is malicious, suspicious, or benign.
3. **User Engagement**: Contact users for context—did they click, reply, or enter credentials?
4. **Investigation**: Pivot to host/network logs, check for payload execution, lateral movement, and spread.
5. **Remediation & Containment**: Quarantine emails, block domains/URLs, reset credentials, revoke sessions.
6. **Detection Tuning & Feedback**: Adjust rules, reduce false positives, improve coverage.
7. **Documentation & Reporting**: Record findings, actions, and lessons learned in ticketing/case management systems.

### SOC Analyst Tips & Best Practices
- Use a proven triage framework: header/source analysis, content review, user interaction check, remediation, documentation
- Avoid interacting with malicious content on your host—use sandboxes and passive tools
- Always check for user interaction and widespread delivery
- Don't assume trust based on SPF/DKIM/DMARC pass—compromised accounts can still send attacks
- Remediate quickly: quarantine, block, reset credentials, revoke sessions
- Document everything: IOCS (IPs, domains, hashes), affected users, actions, verdict, lessons learned

### Final Thoughts
Take your time with investigations, check all the bases, and learn the manual steps before relying on automated tools. Security tools make things easier, but manual review builds intuition and expertise.

## Get Involved!

Have you analyzed a phishing email, spotted a clever spoof, or have tips for email security? Share your experiences, favorite tools, or questions in the comments below—or tag me on social media! :speech_balloon: :shield: :envelope:

Happy hunting!