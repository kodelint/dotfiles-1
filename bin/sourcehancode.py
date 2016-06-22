#!/usr/bin/env python2
import fontforge as ff

CODE_FONT="./SourceCodePro-Medium-Nerd.otf"
HAN_FONT="./SourceHanSansJP-Medium.otf"

c=ff.open(CODE_FONT)
print(c)
c.selection.select(("ranges", None), 0x00, 1114334)
# # c.selection.select(("ranges", None), 0x20, 0x7e)
# # c.selection.select(("ranges", None), 0x4e0d, 0x7c3e)
c.selection.invert()
c.clear()
c.cidConvertTo('Adobe', 'Identity', 0)
c.generate("_scpascii.otf")
c.close()
#
# c=ff.open("_scpascii.otf")
# c.selection.select(("ranges", None), 0xe0a0, 0xe0d7)
# c.copy()
# c.close()
#
# h=ff.open(HAN_FONT)
# # h.cidsubfont=h.cidsubfontnames.index('SourceHanSansJP-Medium-Proportional')
# # print(h.cidsubfontnames[15])
# # h.cidsubfont=h.cidsubfontnames[15]
# # print(h)
# # h.selection.select(("ranges", None), 1, 0x5f)
# # h.selection.select(("ranges", None), 0, -1)
# # h.selection.select(("ranges", None), 0x4e0d, 0x7c3e)
# h.paste()
#
# h.cidfullname="Source Han Code JP Medium"
# h.cidfamilyname="Source Han Code JP"
# h.cidfontname="SourceHanCodeJP-Medium"
#
# h.generate("_scp.otf")
# h.close()
#
# from fontTools.ttLib import TTFont
#
# nameIDs={
#     "Copyright":         0,
#     "Family":            1,
#     "SubFamily":         2,
#     "UniqueID":          3,
#     "Fullname":          4,
#     "Version":           5,
#     "PostScriptName":    6,
#     "Trademark":         7,
#     "Manufacturer":      8,
#     "Designer":          9,
#     "Descriptor":        10,
#     "Vendor URL":        11,
#     "Designer URL":      12,
#     "License":           13,
#     "License URL":       14,
#     "Preferred Family":  16,
#     "Preferred Styles":  17,
#     "Compatible Full":   18,
#     "Sample Text":       19,
#     "CID findfont Name": 20,
#     "WWS Family":        21,
#     "WWS Subfamily":     22
# }
#
# def nameRecodeIsUnicode(n):
#     return (n.platformID == 0 or
#             (n.platformID == 3 and n.platEncID in [0, 1, 10]))
#
# def setString(names, nameID, string):
#     for n in names:
#         if n.nameID == nameIDs[nameID]:
#             n.string=string
#             if nameRecodeIsUnicode(n):
#                 n.string=n.string.encode("utf-16-be")
#
# def getString(nametable, nameID, platformID, platEncID, langID=None):
#     name = nametable.getName(nameID, platformID, platEncID, langID)
#     if name is None:
#         return None
#         if nameRecodeIsUnicode(name):
#             return unicode(name.string, "utf-16-be")
#         else:
#             return name.string
#
# hfont=TTFont(HAN_FONT)
# hfont.saveXML("_cmap.ttx", tables=["cmap"])
#
# font=TTFont("_scp.otf")
# font.importXML("_cmap.ttx")
# name=font['name']
# name.names=[ n for n in name.names if n.langID != 0x411]
# setString(name.names, 'Family', "Source Han Code JP Medium")
# setString(name.names, 'Fullname', "Source Han Code JP Medium")
# setString(name.names, 'Preferred Family', "Source Han Code JP")
# setString(name.names, 'UniqueID', '1.001;ADBE;SourceHanCodeJP-Medium;ADOBE')
# print font['name'].getName(6, 1, 0).string
#
# font.save('SourceHanCodeJP-Medium.otf')
