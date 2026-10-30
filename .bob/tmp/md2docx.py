import re, sys
from docx import Document
from docx.shared import Pt, RGBColor, Cm
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

src, dst = sys.argv[1], sys.argv[2]
FONT = "Microsoft JhengHei"

doc = Document()
sec = doc.sections[0]
sec.left_margin = sec.right_margin = Cm(2)
sec.top_margin = sec.bottom_margin = Cm(2)

def set_font(style, size=None, bold=None, color=None):
    style.font.name = FONT
    style.element.rPr.rFonts.set(qn("w:eastAsia"), FONT)
    if size: style.font.size = Pt(size)
    if bold is not None: style.font.bold = bold
    if color: style.font.color.rgb = RGBColor(*color)

set_font(doc.styles["Normal"], 10)
for name, size in (("Heading 1", 18), ("Heading 2", 14), ("Heading 3", 12), ("Title", 22)):
    set_font(doc.styles[name], size, True, (0x0F, 0x62, 0xFE))

def shade(cell, hex_color):
    tcPr = cell._tc.get_or_add_tcPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:val"), "clear"); shd.set(qn("w:color"), "auto"); shd.set(qn("w:fill"), hex_color)
    tcPr.append(shd)


def ppr_insert(pPr, el):
    """依 OOXML 順序插入 pBdr/shd：須在 spacing/ind/jc 等之前。"""
    order_after = ("tabs","suppressAutoHyphens","kinsoku","wordWrap","overflowPunct","topLinePunct","autoSpaceDE","autoSpaceDN","bidi","adjustRightInd","snapToGrid","spacing","ind","contextualSpacing","mirrorIndents","suppressOverlap","jc","textDirection","textAlignment","textboxTightWrap","outlineLvl","divId","cnfStyle","rPr","sectPr","pPrChange")
    for child in list(pPr):
        if child.tag.split('}')[1] in order_after:
            child.addprevious(el); return
    pPr.append(el)
TOKEN = re.compile(r"(\*\*[^*]+\*\*|`[^`]+`|\*[^*\s][^*]*\*)")

def add_runs(par, text, bold=False, italic=False):
    text = text.replace("<br/>", "\n").replace("<br>", "\n")
    for part in TOKEN.split(text):
        if not part:
            continue
        if part.startswith("**") and part.endswith("**"):
            r = par.add_run(part[2:-2]); r.bold = True; r.italic = italic
        elif part.startswith("`") and part.endswith("`"):
            r = par.add_run(part[1:-1]); r.font.name = "Consolas"
            r._element.rPr.rFonts.set(qn("w:eastAsia"), FONT)
            r.font.color.rgb = RGBColor(0xA0, 0x20, 0x20); r.bold = bold; r.italic = italic
        elif part.startswith("*") and part.endswith("*") and len(part) > 2:
            r = par.add_run(part[1:-1]); r.italic = True; r.bold = bold
        else:
            r = par.add_run(part); r.bold = bold; r.italic = italic

def split_row(line):
    line = line.strip()
    if line.startswith("|"): line = line[1:]
    if line.endswith("|"): line = line[:-1]
    return [c.strip() for c in line.split("|")]

def add_table(rows):
    header, body = rows[0], rows[1:]
    ncol = len(header)
    t = doc.add_table(rows=1, cols=ncol)
    t.style = "Table Grid"
    for i, h in enumerate(header):
        c = t.rows[0].cells[i]
        c.text = ""
        add_runs(c.paragraphs[0], h, bold=True)
        for r in c.paragraphs[0].runs: r.font.color.rgb = RGBColor(255, 255, 255)
        shade(c, "0F62FE")
    for row in body:
        row = (row + [""] * ncol)[:ncol]
        cells = t.add_row().cells
        for i, v in enumerate(row):
            cells[i].text = ""
            lines = v.split("<br/>") if "<br/>" in v else [v]
            add_runs(cells[i].paragraphs[0], v)
            if i == 0 and ncol > 1:
                shade(cells[i], "EDF5FF")
    for row in t.rows:
        for c in row.cells:
            for p in c.paragraphs:
                p.paragraph_format.space_after = Pt(2)
                for r in p.runs: r.font.size = Pt(9)
    doc.add_paragraph()

def quote(text):
    p = doc.add_paragraph()
    p.paragraph_format.left_indent = Cm(0.6)
    pPr = p._p.get_or_add_pPr()
    bdr = OxmlElement("w:pBdr")
    left = OxmlElement("w:left")
    left.set(qn("w:val"), "single"); left.set(qn("w:sz"), "18"); left.set(qn("w:space"), "6"); left.set(qn("w:color"), "78A9FF")
    bdr.append(left); ppr_insert(pPr, bdr)
    add_runs(p, text)
    for r in p.runs:
        r.font.color.rgb = RGBColor(0x52, 0x52, 0x52); r.font.size = Pt(9.5)

def code_block(lines):
    for ln in lines:
        p = doc.add_paragraph()
        p.paragraph_format.space_after = Pt(0)
        p.paragraph_format.left_indent = Cm(0.5)
        r = p.add_run(ln if ln else " ")
        r.font.name = "Consolas"; r._element.rPr.rFonts.set(qn("w:eastAsia"), FONT)
        r.font.size = Pt(9)
        pPr = p._p.get_or_add_pPr()
        shd = OxmlElement("w:shd"); shd.set(qn("w:val"), "clear"); shd.set(qn("w:fill"), "F4F4F4")
        ppr_insert(pPr, shd)
    doc.add_paragraph()

MERMAID_TEXT = [
    "審批流程：",
    "1. 客戶填寫變更請求",
    "2. Bob／PPZ 團隊完整性檢查（資料不足則退回客戶補充）",
    "3. 技術可行性與風險評估",
    "4. 客戶主機／資安核可（D1–D3）",
    "5. 雙方項目負責人簽署",
    "6. 啟動 POC 並接收程式碼",
]

lines = open(src, encoding="utf-8").read().splitlines()
i = 0
first_h1 = True
while i < len(lines):
    ln = lines[i]
    s = ln.strip()
    if s.startswith("```"):
        lang = s[3:].strip()
        j = i + 1
        buf = []
        while j < len(lines) and not lines[j].strip().startswith("```"):
            buf.append(lines[j]); j += 1
        if lang == "mermaid":
            for k, t in enumerate(MERMAID_TEXT):
                p = doc.add_paragraph(); add_runs(p, t, bold=(k == 0))
        else:
            code_block(buf)
        i = j + 1; continue
    if s == "---":
        i += 1; continue
    if s.startswith("|") and i + 1 < len(lines) and re.match(r"^\s*\|[\s:\-|]+\|\s*$", lines[i + 1]):
        rows = [split_row(ln)]
        j = i + 2
        while j < len(lines) and lines[j].strip().startswith("|"):
            rows.append(split_row(lines[j])); j += 1
        add_table(rows); i = j; continue
    m = re.match(r"^(#{1,3})\s+(.*)", s)
    if m:
        lvl = len(m.group(1)); txt = m.group(2)
        if lvl == 1:
            if first_h1:
                doc.add_heading(txt, 0); first_h1 = False
            else:
                p = doc.add_paragraph(); add_runs(p, txt)
                for r in p.runs: r.font.size = Pt(12); r.font.color.rgb = RGBColor(0x52, 0x52, 0x52)
        else:
            doc.add_heading(txt, lvl - 1)
        i += 1; continue
    if s.startswith(">"):
        buf = []
        while i < len(lines) and lines[i].strip().startswith(">"):
            buf.append(re.sub(r"^>\s?", "", lines[i].strip())); i += 1
        # 合併成區塊，保留列表行
        for b in buf:
            if b.startswith("|") and b.endswith("|") and re.match(r"^\|[\s:\-|]+\|$", b):
                continue
            if b.startswith("|"):
                quote(" ｜ ".join(c for c in split_row(b) if c)); continue
            if b.startswith("- "):
                b = "• " + b[2:]
            if b:
                quote(b)
        continue
    m = re.match(r"^(\s*)([-*]|\d+\.)\s+(.*)", ln)
    if m:
        indent = len(m.group(1)) // 2
        txt = m.group(3)
        is_num = m.group(2)[0].isdigit()
        p = doc.add_paragraph(style="List Number" if is_num else "List Bullet")
        if indent: p.paragraph_format.left_indent = Cm(0.63 * (indent + 1))
        if txt.startswith("[ ]"): txt = "☐ " + txt[3:].strip()
        elif txt.startswith("[x]"): txt = "☑ " + txt[3:].strip()
        add_runs(p, txt)
        i += 1; continue
    if s == "":
        i += 1; continue
    p = doc.add_paragraph()
    add_runs(p, s)
    i += 1

# 勾選框符號轉換（表格內）
for t in doc.tables:
    for row in t.rows:
        for c in row.cells:
            for p in c.paragraphs:
                for r in p.runs:
                    r.text = r.text.replace("[ ]", "☐").replace("[x]", "☑")

# 頁尾頁碼
footer = sec.footer.paragraphs[0]
footer.alignment = WD_ALIGN_PARAGRAPH.CENTER
footer.add_run("Bob + PPZ POC 變更請求範本 v1.0　｜　第 ")
for tag, txt in (("begin", None), (None, "PAGE"), ("end", None)):
    r = footer.add_run()
    if tag:
        f = OxmlElement("w:fldChar"); f.set(qn("w:fldCharType"), tag); r._r.append(f)
    else:
        it = OxmlElement("w:instrText"); it.set(qn("xml:space"), "preserve"); it.text = txt; r._r.append(it)
footer.add_run(" 頁")

doc.save(dst)
print("saved", dst)

