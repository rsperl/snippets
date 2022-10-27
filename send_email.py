import smtplib

email_defaults = {
    "from": "replies-disabled@domain.com",
    "content-type": "text/html",
    "X-Automation": "true",
}

style_sheet = """
<style>
    table, tr, td, th, caption {
        border: 1px solid #929496;
        border-spacing: 0;
        border-collapse: collapse;
        padding: 2px;
        margin: 0;
    }
    caption {
        background: #007DC3;
        border: 1px solid #007DC3;
        color: white;
        font-size: larger;
    }
    td, th, .title {
        font-family: Helvetica;
    }
    td, th {
        vertical-align: top;
        text-align: left;
    }
    .alert td {
        font-weight: bold;
        color: red;
    }
    .footer {
        font-size: smaller;
        font-family: Courier;
        color: gray;
    }
</style>
"""


def do(opts):
    """Takes a dict of args:
      to : list of recipients
      from : sender (defaults to replies-disabled@domain.com)
      content-type: defaults to text/plain, but text/html can be specified
      subject : subject of the email
      body : content of the email

    Any additional keys in args are sent as headers

    example:
        send_email.send_email({ "to" : ["you@there.com"], "subject" : "the subject", "body" : "the body" })
    """
    email = """From: %(from)s
To: %(to)s
MIME-Version: 1.0
Content-Type: %(type)s
X-Automation: true
Subject: %(subject)s
"""
    sender     = opts.get("from", email_defaults.get("from"))
    recipients = opts.get("to", [])
    if not type(recipients) == list:
        raise ValueError("recipients must be a list")
    body = email % {
        "from": sender,
        "to": ",".join(recipients),
        "type": opts.get("content-type", email_defaults.get("content-type")),
        "subject": opts.get("subject", "no subject sent")
    }

    data = opts["body"]

    if "content-type" in opts:
        del opts["content-type"]
    if "subject" in opts:
        del opts["subject"]
    if "to" in opts:
        del opts["to"]
    if "body" in opts:
        del opts["body"]

    for n, v in opts.items():
        body += v + "\n"

    body += "\n" + data

    print(body)

    s = smtplib.SMTP()
    s.connect()
    s.sendmail(sender, recipients, body)
    s.quit()
