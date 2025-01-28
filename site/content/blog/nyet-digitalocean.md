+++
title               = 'НЕТ! DigitalOcean'
scrollingTitleCount = 3
date                = '2025-01-28'
+++

Updated: January 27, 2025.

- Added note that the support staff are probably real people.

Written: January 21, 2025.

---

![Russian anti-alchohol poster with the DigitalOcean logo over the alchohol](/blog/nyet-digitalocean/propaganda.webp)

For the moment, I'm using a CloudFlare tunnel
[https://developers.cloudflare.com/cloudflare-one/connections/connect-networks *(January 21, 2025)*](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)
to give access to my website from the Clearnet. The tunnel is essentially just a
reverse proxy service. People connecting to [https://paltepuk.xyz](https://paltepuk.xyz) are
sent to the tunnel, and the tunnel routes them to my webserver. This is to
protect the IP address of the server, since it resides in my home, and I don't
want script kiddes having easy access to my IP and location.

I'm not paticularly fond of how much control CloudFlare has over the
internet. Many, many, many websites utilize their services, allowing them to
monitor and restrict the traffic going through, and I escpecially hate the
CAPTCHAs. When I'm browsing the internet, I often use the Tor Browser
[https://www.torproject.org *(January 21, 2025)*](https://www.torproject.org/)
(basic hygine and all,) and I often have to go through several websites before I
get to one that will actually let me view the contents. Granted, not all of them
are CloudFlare's fault, but maybe around 50% are.

That said, I don't consider it that big of a deal in paltepuk's case, since I
also have access to my website directly through the Tor and I2P networks, so
privacy concious individuals (a.k.a. normal people) have a way to avoid
CloudFlare's omniprecense.

But, I still wish to remove my dependence on them. I've been looking for a
server hosting provider to rent a VPS from. I figured I could just slap my
website on it, and if it gets DDoS'd, so be it, and since it's IP address will
just be some data center, there's no concern there either. I very much share the
views of the Zig team in this regard
[https://ziglang.org/news/migrate-to-self-hosting *(January 21, 2025)*](https://ziglang.org/news/migrate-to-self-hosting/):

> "...
>
> The thing is, ziglang.org is not an essential service. It's not really an
> emergency if it goes down, and 99% uptime is perfectly fine for this use
> case. The funny thing about that last 1% of uptime is that it represents 99%
> of the costs.
>
> ...
>
> If the website is temporarily unavailable because of too much traffic, so be
> it. If it gets accidentally DDoS'd by too many people not properly caching
> their CI runs, so be it. That's why we sign artifacts with a static public
> key, so that you can use mirrors.
>
> Instead of spending donation money eating these costs which are ultimately due
> to inefficient use of computing resources, we push those otherwise hidden
> costs onto users of Zig, causing Zig users in general to avoid waste, and then
> we have more money to spend on paying contributors for their time.
>
> ..."

Overall, through my searching, I wasn't paticularly satisfied with any of the
options I found. But, around ~6 months ago, I decided to give DigitalOcean
[https://www.digitalocean.com *(January 21,2025)*](https://www.digitalocean.com/)
a shot. This turned out to be a terrible mistake, and one I will not make again.

## Beginning of the End

*Note: the parts of the messages in square brackets are details I have omitted.*

So I go to create my DigitalOcean account, enter the details, and what am I
greeted with?

![Webpage showing that I am locked out of my account and need to contact support](/blog/nyet-digitalocean/locked-out.webp)

Annoying, but I understand. So I go to contact support and make the following ticket:

> From: me{{< br >}}
> Title: Unable to login after creating account{{< br >}}
> Date: July 19, 2024 at 21:42
>
> Attempted to login, but went to page stating "Additional Information Required"

A whole 2 weeks goes by, and... nothing. So I send the following message:

> From: me{{< br >}}
> Date: August 04, 2024 at 07:54
>
> If you're going to hang me out to dry like this, just delete the account

Finally I get a response from their support:

> From: DigitalOcean support{{< br >}}
> Date: August 04, 2024 at 13:49
>
> Hello there,
>
> Thank you for your response.
>
> After a manual review, we are unable to move forward with activating your
> account on our platform at this time. We understand this may not be the
> expected outcome, however, we have examined the details provided and are
> unable to accommodate your request.
>
> We welcome any additional information you can provide to better help us
> understand your business case on DigitalOcean. There are some parameters used
> in the activation reviews that we cannot share for the safety of
> DigitalOcean. As your business case and associated details improve, we
> encourage you to consider DigitalOcean in the future as your provider.
>
> Please do not hesitate to contact us should you require any further
> information or assistance.
>
> Regards,{{< br >}}
> [OMITTED]{{< br >}}
> Associate Customer Advocate{{< br >}}
> DigitalOcean Support{{< br >}}
> \-\-\-{{< br >}}
> We value your feedback! After your ticket closes we will send you an email
> survey, please share a few kind words and let us know how we did.
>
> [ADVERTISEMENT]
>
> ref:[OMITTED]:ref

Fucking great. Not only do I not get access to the account I created, but they
won't even tell me why!

And not only that, THEY THREW AN AD IN THERE! The gall of these shmucks!

So I decided to have them just delete the account:

> From: me{{< br >}}
> Date: August 05, 2024 at 14:59
>
> Yes, I would like to you delete this account, since I can't use it anyways.

A resonable request I would think, but apparently DigitalOcean begs to differ:

> From: DigitalOcean support{{< br >}}
> Date: August 05, 2024 at 07:26 PM
>
> Hey there, Thanks for reaching out.
>
> We acknowledge your request regarding personal data associated with the
> account. However, due to the circumstances surrounding the account, it has
> been deemed potentially fraudulent. In order to ensure the integrity of our
> security measures, we are unable to share any further details regarding the
> status of the account.
>
> Please do not hesitate to contact us should you require any further
> information or assistance.
>
> Regards,{{< br >}}
> [OMITTED]{{< br >}}
> Associate Customer Advocate{{< br >}}
> DigitalOcean Support{{< br >}}
> \-\-\-{{< br >}}
> We value your feedback! After your ticket closes we will send you an email
> survey, please share a few kind words and let us know how we did.
>
> [ADVERTISEMENT]
>
> ref:[OMITTED]:ref

Potentially fradulent... **fradulent!** Are you fucking kidding me!

I decide to be equally petty and send back the following strongly-worded message:

> From: me{{< br >}}
> Date: August 05, 2024 at 19:34
>
> Awesome, thank you so much. I created an account to get a VPS to host my
> website on and I get locked out and ignored for ~2 weeks and then was told I
> can neither use the account or have it deleted. Thank you. "Potentially
> fraudulent" sums up DigitalOcean pretty well.
>
> Don't worry though, I'll never dare to do business with DigitalOcean again.
>
> (This message is not for you, the support staff, but rather your higher-ups.)

Added in the last bit because support staff are probably not the issue here. I
highly doubt I was talking to a person in the first place, but you never know.

I decided to just give up and move on; I can't afford to waste my precious time,
energy, and sanity on their bullshit.

## *Ummm... But Did You Read Their TOS???* 🤓

Yes, I chose to move on, "be the bigger man." That is, ***until*** I recieved
this email:

> From: Team DigitalOcean \<team@info.digitalocean.com\>{{< br >}}
> Date: January 01, 2025 at 16:16
>
> As a valued DigitalOcean customer, we wanted to let you know that we are
> updating the DigitalOcean Terms of Service, Privacy Policy, and other
> policies. These updates will go into effect on January 1, 2025.
>
> We have updated our terms for the following reasons:
>
> - To reflect a recent administrative change wherein the DigitalOcean Managed Hosting Services (Cloudways Services) will now be provided by DigitalOcean, LLC as opposed to Cloudways Ltd., a subsidiary of DigitalOcean, LLC.
>
> - To introduce a Service Terms section with terms specific to certain DigitalOcean services. This new section also contains general Service Terms that apply to all services, as well as terms specific to generative AI features of select DigitalOcean services and our GenAI Platform Service.
>
> - To make other clarifying edits and to reorganize information in a way that is more understandable and accessible to our customers and users.
>
> Please review the updated terms, and note that by continuing to use our
> websites and services on or after January 1, 2025, you will be bound by the
> new Terms of Service, Privacy Policy, and updated policies.
>
> Thank you for being a DigitalOcean customer.
>
> Warmest Regards,
>
> DigitalOcean

Valued customer, huh.

Continuing to use our sevices, huh.

Thank you, huh.

That's right, TOS changes that I did not agree to (but DigitalOcean thinks that
I give conset just by existing after a certain date) to a service that I can't
even use because *THEY WON'T LET ME.*

The memory of the cable guy from South Park rubbing his nipples
[https://www.youtube.com/watch?v=NunTJ_k9M14 *(January 21, 2025*)](https://www.youtube.com/watch?v=NunTJ_k9M14)
vividly entered my mind upon reading this email.

I tried to let it go, I did, but the rage just kept boiling inside me, until ~3
weeks later I decided to contact support again to see if they would delete the
account. When I went to make a ticket, it showed me this:

![Create support ticket menu forcing the topic to be "activate account"](/blog/nyet-digitalocean/create-ticket.webp)

I ham-fisted what I wanted into this menu and hit Submit Ticket, resulting in
this message:

> From: me{{< br >}}
> Date: January 20, 2025 at 16:47
>
> Project Goals: Delete my account. I have recieved a new Terms of Service (TOS)
> in my email that I do not agree to since I haven't been able to use
> DigitialOcean in the first place because I got locked out and DO has refused
> to neither activate my account nor delete it{{< br >}}
> Social Media Profiles:{{< br >}}
> Business Name:{{< br >}}
> Hosting Resources: Nothing anymore

And their response:

> From: DigitalOcean support{{< br >}}
> Date: January 21, 2025 at 02:13
>
> Hi there,
>
> Thank you for contacting DigitalOcean Support!
>
> The account you are inquiring about is currently in a locked state. Once an
> account is locked, it is treated as deleted, and no further action is
> required.
>
> Feel free to reach out if you have any questions or concerns.
>
> Regards,{{< br >}}
> [OMITTED]{{< br >}}
> Associate Customer Advocate{{< br >}}
> DigitalOcean Support
>
> ref:[OMITTED]:ref

As one would expect. At the very least, they didn't put an advertisement in it this time.

"Once an account is locked, it is treated as deleted." *Oh yeah?*

Then why can I log in?

Why can I make tickets?

Why do you still have my email?

So I sent a message to address my concerns:

> From: me{{< br >}}
> Date: January 21, 2025 at 05:13
>
> I want it deleted, not "deactivated and so it is marked as deleted."
>
> If I can still log into it, it is not deleted.
>
> If I can still make tickets, it is not deleted.
>
> If I still receive emails sending me new TOS and saying that I agree to it by
> continuing to use DO's services, it is not deleted. And I quote:
>
>> As a valued DigitalOcean customer, we wanted to let you know that we are
>> updating the DigitalOcean Terms of Service, Privacy Policy, and other
>> policies. These updates will go into effect on January 1, 2025.
>>
>> We have updated our terms for the following reasons:
>>
>> - To reflect a recent administrative change wherein the DigitalOcean Managed Hosting Services (Cloudways Services) will now be provided by DigitalOcean, LLC as opposed to Cloudways Ltd., a subsidiary of DigitalOcean, LLC.
>> - To introduce a Service Terms section with terms specific to certain DigitalOcean services. This new section also contains general Service Terms that apply to all services, as well as terms specific to generative AI features of select DigitalOcean services and our GenAI Platform Service.
>> - To make other clarifying edits and to reorganize information in a way that is more understandable and accessible to our customers and users.
>>
>> Please review the updated terms, and note that by continuing to use our
>> websites and services on or after January 1, 2025, you will be bound by the new
>> Terms of Service, Privacy Policy, and updated policies.
>>
>> Thank you for being a DigitalOcean customer.
>>
>> Warmest Regards,
>>
>> DigitalOcean
>
> Does DO think I am an idiot? It seems like I am for choosing to try and use
> DO's services, and it is not a mistake I will repeat. I just want this trash
> deleted so I can move on with my life.

And, for good measure, I mentioned their previous approach:

> From: me{{< br >}}
> Date: January 21, 2025 at 05:15
>
> Or are you going to pull this shit again?:
>
>> Thanks for reaching out.
>>
>> We acknowledge your request regarding personal data associated with the
>> account. However, due to the circumstances surrounding the account, it has
>> been deemed potentially fraudulent. In order to ensure the integrity of our
>> security measures, we are unable to share any further details regarding the
>> status of the account.
>>
>> Please do not hesitate to contact us should you require any further
>> information or assistance.

And, as one would expect:

> From: DigitalOcean support{{< br >}}
> Date: January 21, 2025 at 08:34
>
> Hello,
>
> Thank you for writing back!
>
> We understand your concern regarding the request to delete the data associated
> with your account. However, after a thorough review, we have determined that
> your account has patterns that potentially fraudulent. As a result, the
> account has been locked.
>
> In line with our security and compliance procedures, we retain the data
> related to your account for further analysis.
>
> We are unable to fulfill the deletion request at this time, but please be
> assured that any data we retain is handled in accordance with our privacy and
> data protection policies.
>
> If you have any additional questions or concerns, please don't hesitate to
> reach out.
>
> Regards,{{< br >}}
> [OMITTED]{{< br >}}
> Associate Customer Advocate
> DigitalOcean Support
>
> ref:[OMITTED]:ref

~~It is with this message that I am certain I never spoke with an actual human.~~

1. ~~Every single time DigitalOcean support sent me a message, the "Associate Customer Advocate" had a different name (which I omitted for privacy in case they are actually human.) If this was an actual person, they would likely have that person, and only that person, handle the ticket unless it needed to be elevated for some reason.~~

2. ~~These responses are heavily similar and seemingly manufactered. If a human is behind these responses, they are more than likely copy-pasting some template response, which may as well be non-human.~~

*Update January 28, 2025:* After spamming their ticketing system a bit, I'm now
*pretty* sure that they are actual people. DigitalOcean is still an asshole though.

And it is with this that I have deciced to conclude any attempts at
communication and write this blog post.

## So, What Did We Learn?

I will never, ever even attempt to use DigitalOcean's services ever again, not
that I can.

If I am discussing hosting options with coworkers for a project for any
companies that I may work for, or if I am doing some kind of consultation for a
company/individual, I will strongly advise them against DigitalOcean, and cite
my experiences with them.

I urge you, the person reading this, to not use DigialOcean's services, and if
you are, to make steps to move away from them as soon as possible.

I will do more research next time, in the hopes that I can find out if a company
does this bullshit ahead of time and avoid them completely.

## Possible Amendments

If DigitalOcean staff ~~, and by that, I mean an actual human,~~ is reading this
blog post, the IDs for the first two tickets I made are #09202901 and #10077911.

If my issues are rectified, then I will *amend* this blog post, but not delete
it, stating that DigitalOcean did so.
