#!/usr/bin/env python3

"""
Add text to a PDF
"""

import os
import argparse
import tempfile
from venv import create
from copy import deepcopy
from PyPDF4 import PdfFileReader, PdfFileWriter
from reportlab.lib.pagesizes import landscape, letter, portrait
from reportlab.pdfbase.pdfmetrics import registerFont
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen.canvas import Canvas


def parseargs() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Add text to a base pdf")
    p.add_argument(
        "--base-file",
        required=True,
        help="base file onto which text will be applied",
    )
    p.add_argument(
        "--text",
        help="text to add to base file; if --text begins with '@', the argument is assumed to be a file, and each line should be processed as --text",
        required=True,
    )
    p.add_argument("--font-name", default="Arial", help="font name to use")
    p.add_argument("--font-size", default=48, help="font size")
    pagesize = landscape(letter)
    p.add_argument(
        "--page-orientation",
        default="landscape",
        choices=["landscape", "letter"],
        help="page orientation",
    )
    p.add_argument(
        "--x-center-offset", default=0, help="x offset from center", type=int
    )
    p.add_argument(
        "--y-center-offset", default=0, help="y offset from center", type=int
    )
    p.add_argument("--outdir", help="output directory", default=".")
    p.add_argument("--outfile", help="name of output file (default is --text)")
    p.add_argument(
        "--outfile-prefix",
        help="prefix given to outfile. Useful if generating lots of files that need common prefix",
    )
    args = p.parse_args()

    if not args.outfile:
        args.outfile = args.text + ".pdf"

    if args.outfile_prefix:
        args.outfile = args.prefix + args.outfile

    if args.page_orientation == "portrait":
        pagesize = portrait(letter)
        args.x, args.y = pagesize[0], pagesize[1]
    return args


def createWatermarkFile(
    filename: str,
    text: str,
    text_size: int = 48,
    font_name: str = "",
    x_center_offset: int = 0,
    y_center_offset: int = 0,
):
    """
    Create a blank PDF with the given text that will be merged onto another page
    """
    pagesize = landscape(letter)
    x, y = pagesize[0] / 2 + x_center_offset, pagesize[1] / 2 + y_center_offset
    watermark = Canvas(filename, pagesize=pagesize)
    if font_name:
        font = TTFont(font_name, font_name + ".ttf")
        registerFont(font)
        watermark.setFont(font_name, text_size)
    else:
        watermark.setFontSize(text_size)
    watermark.drawCentredString(x, y, text)
    watermark.save()


def add_text(base_filename: str, out_filename: str, watermark_filename: str) -> str:
    """
    Merge the given watermark pdf with the base file and save as out_filename
    """
    with open(watermark_filename, "rb") as w_fh:
        watermark = PdfFileReader(w_fh)
        out_pdf = PdfFileWriter()
        with open(base_filename, "rb") as fh:
            in_pdf = PdfFileReader(fh)
            in_page = in_pdf.getPage(0)
            in_page.mergePage(watermark.getPage(0))
            out_pdf.addPage(in_page)
            with open(out_filename, "wb") as outputStream:
                out_pdf.write(outputStream)

    os.unlink(watermark_filename)


if __name__ == "__main__":
    # fontName = "Helvetica"
    args = parseargs()

    # setup for a single run, but if a file is given,
    # text and filename will be overwritten at each run
    watermark_args = {
        "filename": tempfile.mktemp(),
        "text": args.text,
        "text_size": args.font_size,
        "font_name": args.font_name,
        "x_center_offset": args.x_center_offset,
        "y_center_offset": args.y_center_offset,
    }
    if args.text.startswith("@"):
        with open(args.text[1:]) as fh:
            for line in fh:
                line = line.strip()
                outfile = line + ".pdf"
                if args.outfile_prefix:
                    outfile = args.prefix + outfile
                if args.outdir:
                    outfile = args.outdir + "/" + outfile
                this_args = deepcopy(watermark_args)
                this_args["text"] = line
                this_args["filename"] = tempfile.mktemp()
                createWatermarkFile(**this_args)
                add_text(
                    args.base_file, outfile, watermark_filename=this_args["filename"]
                )
    else:
        createWatermarkFile(**watermark_args)
        outfile = args.outfile
        if args.outdir:
            outfile = args.outdir + "/" + outfile
        add_text(args.base_file, outfile, watermark_filename=watermark_args["filename"])
