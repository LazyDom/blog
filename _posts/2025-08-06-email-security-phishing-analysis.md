---
layout: post
title: "Email Security: How to Spot and Analyze Phishing Attacks"
categories: [security, email, phishing, analysis]
description: A practical guide to understanding, detecting, and analyzing phishing emails using real-world techniques and tools.
tagline: Strengthen your defenses—spot phishing before it strikes!
medium_url: 
gist_url: https://gist.github.com/LazyDom/5e492eab74853d8ed840f3692001bbb4
author: LazyDom
date: 2025-08-08
---

## Why Email Security Matters :lock:

Most organizations rely on email as their primary means of communication, making it a major attack channel with significant financial risk.

Common Email Threats:
- **Phishing**: Trick users into clicking malicious links or attachments
- **Spear Phishing**: Targeted attacks on individuals or organizations
- **Business Email Compromise (BEC)**: Impersonation of trusted contacts
- **Account Takeover (ATO)**: Using real accounts for further attacks
- **Malicious Attachments/Malware**: Files that deliver malware
- **Quishing & Emerging Attacks**: QR code phishing, AI-generated emails, calendar invites

Phishing emails use manipulative, high‑impact language: “you have won a gift,” “don’t miss out on the big discount,” “your account will be suspended,” “immediate action required,” “unusual sign‑in detected,” or “final notice – payment failure.” Beyond stealing credentials, the real objective is exploiting urgency, fear, curiosity, financial pressure, or authority—the human factor (still the weakest link). Attackers weaponize time pressure (deadlines, expiring access), consequences (account closure, legal escalation), and rewards (refunds, bonuses) to short‑circuit judgment.
Email is often the first point in the kill chain—defending it early reduces downstream compromise.
<!--more-->

### Information Gathering & Spoofing :performing_arts:

Because emails don’t always have authentication, attackers can send messages pretending to be someone else. Spoofing tricks users into trusting fake emails. Protocols like SPF, DKIM, and DMARC help verify senders, but aren’t always enforced.

- **SPF** (Sender Policy Framework) – Lists which servers are allowed to send for a domain.
- **DKIM** (DomainKeys Identified Mail) – Cryptographically signs parts of a message to prove integrity & domain control.
- **DMARC** (Domain-based Message Authentication, Reporting & Conformance) – Policy layer telling receivers how to handle SPF/DKIM alignment failures (none / quarantine / reject).

To check if an email is spoofed, use tools like [MXToolbox](https://mxtoolbox.com/) to compare SPF, DKIM, DMARC, and MX records. Also, check the SMTP IP address with Whois records.

> **Tip:** Even if the sender isn’t spoofed (SPF/DKIM/DMARC pass), compromised accounts can send malicious emails. Always validate intent and context.

---

### Email Traffic Analysis :satellite:

Analyzing phishing attacks involves checking sender addresses, SMTP IPs, domains, subjects, recipients, and timestamps. If malicious emails target the same users repeatedly, their addresses may be leaked online (e.g., PasteBin).

Attackers can harvest emails using tools like Harvester on Kali Linux. Avoid posting personal emails publicly.

If emails arrive outside of expected business hours, the attacker may be operating from a different time zone—another context clue.

---

## What is an Email Header & How to Read It? :mailbox:

The header contains sender, recipient, date, and routing info. Key fields include:

- **From:** Sender’s name/email
- **To:** Recipient’s name/email (plus CC/BCC)
- **Date:** When the email was sent
- **Subject:** Topic of the email
- **Return-Path:** Where replies (bounces) go
- **Message-ID:** Unique email identifier
- **Received:** List of mail servers the email passed through (chronological path)
- **X-Spam Status:** Spam score and classification

To access headers:
- **Gmail:** Open email → 3 dots → Download message (.eml)
- **Outlook:** Open email → File → Info → Properties → Internet headers
- **Reference:** Multi-client guide: [How to get full email headers](https://mxtoolbox.com/EmailHeaders.aspx)

> See the example triage workflow in the next section for how to interpret these fields quickly.

---

## Email Header Analysis :male_detective:

When you suspect phishing, ask:
- Was the email sent from the correct SMTP server?
- Are the “From” and “Return-Path/Reply-To” fields the same?

### Example: Fast Triage of a Bulk Recruitment Email
> Sample below shows how much signal you can extract quickly without reading the entire raw message.

#### Minimal Forensic Header Slice (Example)
> **Disclaimer:** The following header and body samples have been defanged and redacted for privacy and safety. Do not use real, unredacted samples in public posts. Always sanitize sensitive data before sharing.

Download: [Defanged & Redacted .eml sample (Gist)]({{ page.gist_url }})

```
Return-Path: <bounce[@]bounces[.]terrigenisis[.]com>
From: "Mantra Falcon" <maha+email[@]talent[.]terrigenisis[.]com>
To: victim[@]example[.]com
Subject: Sr. AI Engineer opening
Date: Wed, 6 Aug 2025 17:53:06 -0400
Message-ID: <955445473.62711.7145517168948[@]ip-10[.]47[.]164[.]231[.]ec2[.]internal>
Received: from [10[.]90[.]23[.]234] (internal) by sparkpost REST
Received: from terrigenisis-talentplatform (hxxp://182[.]247[.]176[.]30) by mx[.]google[.]com (TLS1.2)
Authentication-Results: dkim=pass spf=pass dmarc=pass
List-Unsubscribe: <mailto:unsubscribe[@]...>, <hxxps://unsubscribe[.]spmta[.]com/...>
Tracking-Link: hxxps://tracking[.]terrigenisis[.]com/...
```

#### What This Tells Us (Fast Triage)

| **Indicator** | **Analytical Meaning** |
|-----------|--------------------|
| Origin IP `182[.]247[.]176[.]30` | Public sending source; run reputation & geo lookups; pivot to threat intel / campaign overlaps. |
| Private hop `10[.]90[.]23[.]234` | Internal ESP (email service provider) injection point; normal for bulk delivery; neutral alone. |
| SPF / DKIM / DMARC = pass | Authentication alignment present; does NOT prove benign intent (compromised or abused account still possible). |
| Bulk markers (`Precedence: bulk`, `List-Unsubscribe`, tracking link/pixel) | Commercial / marketing style; may still deliver phishing lure or lead-gen style credential harvest. |
| Subject + tracking domain mismatch | Brand or infrastructure inconsistency; validate if domain legitimately represents the sender. |
| Message-ID contains `ec2.internal` | Indicates cloud-hosted sending node (likely AWS); supports bulk automation hypothesis. |
| Dual unsubscribe (mailto + HTTPS) | Typical compliant ESP mass mail pattern; lowers chance of crude spoof but intent still must be vetted. |

> **Tip:** Even if the sender isn’t spoofed (SPF/DKIM/DMARC pass), compromised accounts can send malicious emails. Always validate intent and context.

<details>
  <summary>▼ Click to expand: Raw Header & Body Snippet (Truncated) ▼</summary>

```text
Delivered-To: victim[@]example[.]com
Received: by 2002:a05:6918:9e90:... Wed, 6 Aug 2025 14:53:08 -0700 (PDT)
X-Received: by 2002:a05:6902:13c7:...
ARC-Seal: i=1; a=rsa-sha256; ...
ARC-Message-Signature: i=1; ...
ARC-Authentication-Results: i=1; mx[.]google[.]com; dkim=pass; spf=pass; dmarc=pass
Return-Path: <msprvs1=203139...[@]bounces[.]terrigenisis[.]com>
Received: from terrigenisis-talentplatform-166130[.]email[.]terrigenisis[.]tools (hxxp://182[.]247[.]176[.]30) ...
Received-SPF: pass ... client-ip=hxxp://182[.]247[.]176[.]30;
Authentication-Results: mx[.]google[.]com; dkim=pass; spf=pass; dmarc=pass
DKIM-Signature: v=1; a=rsa-sha256; d=talent[.]terrigenisis[.]com; ...
Received: from [10[.]90[.]23[.]234] ... sparkpost ...
Date: Wed, 6 Aug 2025 17:53:06 -0400 (EDT)
From: Mantra Falcon <maha+email+tag[@]talent[.]terrigenisis[.]com>
Reply-To: Mantra Falcon <maha+email+tag[@]talent[.]terrigenisis[.]com>
Subject: Sr. AI Engineer opening
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary="----=_Part_62709_154369604.1754517186981"
Precedence: bulk
List-Unsubscribe: <mailto:unsubscribe[@]unsub[.]spmta[.]com?...>, <hxxps://unsubscribe[.]spmta[.]com/u/...>

-- Body (text/plain excerpt) --
Thank you for your interest in the Sr. AI Engineer opening... (truncated)
-- Body (HTML excerpt) --
<p>Thank you for your interest ... tracking links ...</p>
```
</details>

- Use [MXToolbox](https://mxtoolbox.com/) to check the domain’s MX servers. If the sender’s SMTP IP doesn’t match, it’s likely spoofed.
- Compare “From” and “Reply-To”—if they differ, be suspicious. But always consider the full context (attachments, URLs, content).
- New domains in emails are often used for phishing.
- Trace email hops and analyze headers:
    - Start from the bottom of the header (closest to To/From)
    - Examine each "Received" line for mail server, IP, and domain
    - Identify the originating/public source IP (earliest untrusted hop) to drive reputation checks
    - Look for forged indicators: out‑of‑order or impossible timestamps, future dates, negative transit times
    - Flag private (RFC1918), loopback (127.0.0.1), or link‑local addresses in an external path (often header manipulation)
    - Check HELO/EHLO hostname vs rDNS and SPF-authorized sending hosts (mismatch can indicate spoofing)
    - Note latency anomalies (large gaps between hops) that may signal detours, filtering, sandboxing, or queueing abuse
    - Observe geo / time zone shifts between consecutive relays (sudden country jumps can be suspicious)
    - Capture the injection point (first Received line added after leaving sender’s environment)
    - Verify internal relay pattern (missing expected gateways can imply a bypass)
    - Review TLS annotations (if present) to see which hops downgraded or removed encryption
    - Correlate sending IP with SPF / DKIM / DMARC results for alignment or policy failure
    - Consolidate into a structured timeline: hop number, server, IP, rDNS, timestamp, delta, anomalies
    - Use tools like [MXToolbox](https://mxtoolbox.com/) or [GlockApps](https://glockapps.com/) for analysis

> Received header analysis can be complex—consider using dedicated tools or services for deep dives.

**Is delegated access configured on the mailbox?**  
Check for mailbox delegates.

**Is there a forwarding rule configured for the mailbox?**  
Review mailboxes for SMTP forwarding and Inbox rules that send mail externally. Investigate rules with external addresses or suspicious keywords.

**Review mail transport rules**  
Audit Exchange mail flow (transport) rules for new or modified rules that redirect mail to external domains.

---

## Static Analysis :alembic:

HTML emails can hide malicious links behind buttons or text. Always hover to check the real URL.

- Use [VirusTotal](https://www.virustotal.com/) to check URLs/files for malicious activity.

> Hash search preferred over file upload to avoid tipping off attackers.

> Check the scan date—old results may not reflect current threats.

**Caution:** Uploading files to VirusTotal can leak sensitive data—prefer hash lookups when possible.
- Use [Trend Micro Site Safety Check](https://global.sitesafety.trendmicro.com/) for URL reputation
- Use [Talos Intelligence](https://talosintelligence.com/) and [AbuseIPDB](https://abuseipdb.com/) to check SMTP IP and URL reputation.

---

## Dynamic Analysis :gear:

Never run suspicious files on your own computer. Use sandbox environments like:

- [VMRay](https://www.vmray.com/)
- [JoeSandbox](https://www.joesandbox.com/)
- [AnyRun](https://any.run/)
- [Hybrid Analysis](https://www.hybrid-analysis.com/)

Online browsers like [Browserling](https://www.browserling.com/) let you safely check URLs. Always sanitize personal info before visiting suspicious sites.

> Malware may delay its actions to evade detection—be patient during analysis.

> The absence of URLs or attachments does not guarantee safety; payloads can hide in images or encoded HTML.

---

## Delivery & Evasion Techniques Attackers Use :construction:
Attackers may use legitimate services to bypass filters:
- **Cloud storage links** (Google Drive, Microsoft OneDrive)
- **Free subdomains** (WordPress, Blogspot, Wix)
- **Form apps** (Google Forms)

These can trick users and analysts by appearing harmless.

### SOC Analyst Workflow: How Investigations Happen :hammer_and_wrench:
SOC analyst's workflow for investigating suspicious emails:

1. **Monitoring & Detection**: Analysts use email gateways, EDR/XDR, SIEM, and user reports to monitor alerts.
2. **Triage**: Examine headers, links, attachments, sender behavior. Decide if the email is malicious, suspicious, or benign.
3. **User Engagement**: Contact users for context—did they click, reply, or enter credentials?
4. **Investigation**: Pivot to host/network logs on EDR/XDR & SIEM, check for payload execution, lateral movement, and spread.
    
    **Phishing Investigation Checklist**

    Use this checklist to guide your investigation of a suspected phishing email:

        [ ] Review initial phishing email
        [ ] Get the list of users who received this email
        [ ] Get the latest dates when each user had access to their mailbox
        [ ] Is delegated access configured on the mailbox?
        [ ] Is there a forwarding rule configured for the mailbox?
        [ ] Review mail transport rules
        [ ] Find the email(s)
        [ ] Did the user read/open the email?
        [ ] Who else got the same email?
        [ ] Did the email contain an attachment?
        [ ] Was there a payload in the attachment?
        [ ] Check email header for true source of the sender
        [ ] Verify IP addresses for links to attackers/campaigns
        [ ] Did the user click the link in the email?
        [ ] On what endpoint was the email opened?
        [ ] Was the attachment payload executed?
        [ ] Was the destination IP/URL touched or opened?
        [ ] Was malicious code executed?
        [ ] What sign-ins happened with the account? (SSO logins, MFAs)
        [ ] Investigate source IP address
        [ ] Investigate device(s) that interacted

5. **Remediation & Containment**: Isolate infected endpoints, quarantine or delete emails, block hashes/IPs/domains/URLs, lock compromised user accounts, reset credentials, revoke sessions.
    > Initiate a Host scan, use anti-malware software, or Next-Generation Antivirus (NGAV) if available, to scan affected systems and ensure all malicious content is removed after reimaging.

    > Take a forensic image of the affected system(s) (e.g., **FTK**, **EnCase**) before wiping. This preserves evidence for legal or retrospective analysis.
6. **Detection Tuning & Feedback**: Adjust rules, reduce false positives, improve coverage.
7. **Documentation & Reporting**: Record findings, actions, and lessons learned in ticketing/case management systems.

### SOC Analyst Tips & Best Practices :bulb:
- Use a proven triage framework: header/source analysis → content review → user interaction → remediation → documentation
- Avoid interacting with malicious content on your host—use sandboxes and passive tools
- Always check for user interaction and widespread delivery
- Don’t assume trust based on SPF/DKIM/DMARC pass—compromised accounts can still send attacks
- Remediate quickly: quarantine, block, reset credentials, revoke sessions
- Document everything: IOCs (hashes, IPs, domains, URLs, files), affected users, actions, verdict, lessons learned

### Final Thoughts :white_check_mark:
Take your time with investigations, check all the bases, and learn the manual steps before relying on automated tools. Security tools make things easier, but manual review builds intuition and expertise.

## Get Involved! :mega:

Have you analyzed a phishing email, spotted a clever spoof, or have tips for email security? Share your experiences, favorite tools, or questions in the comments below—or tag me on social media.

Happy hunting!