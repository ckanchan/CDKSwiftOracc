//Copyright Simo Parpola and the Neo-Assyrian Text Corpus Project, 1987. Lemmatised by Mikko Luukko, 2009-11, as part of the AHRC-funded research project “Mechanisms of Communication in an Ancient Empire: The Correspondence between the King of Assyria and his Magnates in the 8th Century BC” (AH/F016581/1; University College London). The annotated edition is released under the Creative Commons Attribution Share-Alike license 3.0.

let P334176 = """
{
"type": "cdl",
"project": "saao/saa01",
"source": "http://oracc.org/saao/saa01",
"license": "This data is released under the CC0 license",
"license-url": "https://creativecommons.org/publicdomain/zero/1.0/",
"more-info": "http://oracc.org/doc/opendata/",
"UTC-timestamp": "2017-06-21T23:21:57",
"textid": "P334176",
"cdl": [
{
"node": "c",
"type": "text",
"id": "P334176.U0",
"cdl": [
{
"node": "d",
"type": "object",
"ref": ""
},
{
"node": "d",
"subtype": "obverse",
"type": "obverse",
"ref": "P334176.o.1",
"label": "o"
},
{
"node": "c",
"type": "discourse",
"subtype": "body",
"id": "P334176.U1",
"cdl": [
{
"node": "c",
"type": "sentence",
"id": "P334176.U2",
"label": "o 1 - o 3",
"cdl": [
{
"node": "d",
"type": "line-start",
"ref": "P334176.2",
"n": "1",
"label": "o 1"
},
{
"node": "l",
"frag": "[a-na]",
"id": "P334176.l03255",
"ref": "P334176.2.1",
"inst": "ana[to]PRP",
"sig": "@saao/saa01%akk-x-neoass:a-na=ana[to//to]PRP'PRP$ana",
"f": {
"lang": "akk-x-neoass",
"form": "a-na",
"delim": " ",
"gdl": [
{
"v": "a",
"gdl_utf8": "𒀀",
"id": "P334176.2.1.0",
"breakStart": "1",
"o": "[",
"break": "missing",
"delim": "-"
},
{
"v": "na",
"gdl_utf8": "𒈾",
"id": "P334176.2.1.1",
"break": "missing",
"o": "]",
"breakEnd": "P334176.2.1.0"
}
],
"cf": "ana",
"gw": "to",
"sense": "to",
"norm": "ana",
"pos": "PRP",
"epos": "PRP"
}
},
{
"node": "l",
"frag": "LUGAL",
"id": "P334176.l03256",
"ref": "P334176.2.2",
"inst": "šarri[king]N",
"sig": "@saao/saa01%akk-x-neoass:LUGAL=šarru[king//king]N'N$šarri",
"f": {
"lang": "akk-x-neoass",
"form": "LUGAL",
"delim": " ",
"gdl": [
{
"s": "LUGAL",
"gdl_utf8": "𒈗",
"id": "P334176.2.2.0",
"role": "logo",
"logolang": "sux"
}
],
"cf": "šarru",
"gw": "king",
"sense": "king",
"norm": "šarri",
"pos": "N",
"epos": "N"
}
},
{
"node": "l",
"frag": "EN-ia",
"id": "P334176.l03257",
"ref": "P334176.2.3",
"inst": "bēlīya[lord]N",
"sig": "@saao/saa01%akk-x-neoass:EN-ia=bēlu[lord//lord]N'N$bēlīya",
"f": {
"lang": "akk-x-neoass",
"form": "EN-ia",
"gdl": [
{
"s": "EN",
"gdl_utf8": "𒂗",
"id": "P334176.2.3.0",
"role": "logo",
"logolang": "sux",
"delim": "-"
},
{
"v": "ia",
"gdl_utf8": "𒅀",
"id": "P334176.2.3.1"
}
],
"cf": "bēlu",
"gw": "lord",
"sense": "lord",
"norm": "bēlīya",
"pos": "N",
"epos": "N"
}
},
{
"node": "d",
"type": "line-start",
"ref": "P334176.3",
"n": "2",
"label": "o 2"
},
{
"node": "l",
"frag": "[ARAD]-⸢ka⸣",
"id": "P334176.l03258",
"ref": "P334176.3.1",
"inst": "urdaka[servant]N",
"sig": "@saao/saa01%akk-x-neoass:ARAD-ka=ardu[slave//servant]N'N$urdaka",
"f": {
"lang": "akk-x-neoass",
"form": "ARAD-ka",
"delim": " ",
"gdl": [
{
"s": "ARAD",
"gdl_utf8": "𒀴",
"id": "P334176.3.1.0",
"breakStart": "1",
"o": "]",
"break": "missing",
"role": "logo",
"logolang": "sux",
"breakEnd": "P334176.3.1.0",
"delim": "-"
},
{
"v": "ka",
"gdl_utf8": "𒅗",
"id": "P334176.3.1.1",
"break": "damaged",
"ho": "1",
"hc": "1"
}
],
"cf": "ardu",
"gw": "slave",
"sense": "servant",
"norm": "urdaka",
"pos": "N",
"epos": "N"
}
},
{
"node": "l",
"frag": "{1}aš-šur-ba-⸢ni⸣",
"id": "P334176.l03259",
"ref": "P334176.3.2",
"inst": "Aššur-bani[1]PN",
"sig": "@saao/saa01%akk-x-neoass:{1}aš-šur-ba-ni=Aššur-bani[1//1]PN'PN$Aššur-bani",
"f": {
"lang": "akk-x-neoass",
"form": "{1}aš-šur-ba-ni",
"gdl": [
{
"det": "semantic",
"pos": "pre",
"seq": [
{
"n": "n",
"sexified": "1(diš)",
"form": "1",
"gdl_utf8": "𒁹",
"id": "P334176.3.2.0",
"seq": [
{
"r": "1"
}
]
}
]
},
{
"v": "aš",
"gdl_utf8": "𒀸",
"id": "P334176.3.2.1",
"delim": "-"
},
{
"v": "šur",
"gdl_utf8": "𒋩",
"id": "P334176.3.2.2",
"delim": "--",
"gdl_em": "1"
},
{
"v": "ba",
"gdl_utf8": "𒁀",
"id": "P334176.3.2.3",
"delim": "-"
},
{
"v": "ni",
"gdl_utf8": "𒉌",
"id": "P334176.3.2.4",
"break": "damaged",
"ho": "1",
"hc": "1"
}
],
"cf": "Aššur-bani",
"gw": "1",
"sense": "1",
"norm": "Aššur-bani",
"pos": "PN",
"epos": "PN"
}
},
{
"node": "d",
"type": "line-start",
"ref": "P334176.4",
"n": "3",
"label": "o 3"
},
{
"node": "l",
"frag": "[lu",
"id": "P334176.l0325a",
"ref": "P334176.4.1",
"inst": "lū[may]MOD",
"sig": "@saao/saa01%akk-x-neoass:lu=lū[may//may]MOD'MOD$lū",
"f": {
"lang": "akk-x-neoass",
"form": "lu",
"delim": " ",
"gdl": [
{
"v": "lu",
"gdl_utf8": "𒇻",
"id": "P334176.4.1.0",
"breakStart": "1",
"o": "[",
"break": "missing"
}
],
"cf": "lū",
"gw": "may",
"sense": "may",
"norm": "lū",
"pos": "MOD",
"epos": "MOD"
}
},
{
"node": "l",
"frag": "DI]-⸢mu",
"id": "P334176.l0325b",
"ref": "P334176.4.2",
"inst": "šulmu[health]N",
"sig": "@saao/saa01%akk-x-neoass:DI-mu=šulmu[completeness//health]N'N$šulmu",
"f": {
"lang": "akk-x-neoass",
"form": "DI-mu",
"delim": " ",
"gdl": [
{
"s": "DI",
"gdl_utf8": "𒁲",
"id": "P334176.4.2.0",
"break": "missing",
"role": "logo",
"logolang": "sux",
"o": "]",
"breakEnd": "P334176.4.1.0",
"delim": "-"
},
{
"v": "mu",
"gdl_utf8": "𒈬",
"id": "P334176.4.2.1",
"break": "damaged",
"gdl_collated": "1",
"ho": "1"
}
],
"cf": "šulmu",
"gw": "completeness",
"sense": "health",
"norm": "šulmu",
"pos": "N",
"epos": "N"
}
},
{
"node": "l",
"frag": "a-na⸣",
"id": "P334176.l0325c",
"ref": "P334176.4.3",
"inst": "ana[to]PRP",
"sig": "@saao/saa01%akk-x-neoass:a-na=ana[to//to]PRP'PRP$ana",
"f": {
"lang": "akk-x-neoass",
"form": "a-na",
"delim": " ",
"gdl": [
{
"v": "a",
"gdl_utf8": "𒀀",
"id": "P334176.4.3.0",
"break": "damaged",
"gdl_collated": "1",
"delim": "-"
},
{
"v": "na",
"gdl_utf8": "𒈾",
"id": "P334176.4.3.1",
"break": "damaged",
"gdl_collated": "1",
"hc": "1"
}
],
"cf": "ana",
"gw": "to",
"sense": "to",
"norm": "ana",
"pos": "PRP",
"epos": "PRP"
}
},
{
"node": "l",
"frag": "[LUGAL",
"id": "P334176.l0325d",
"ref": "P334176.4.4",
"inst": "šarri[king]N",
"sig": "@saao/saa01%akk-x-neoass:LUGAL=šarru[king//king]N'N$šarri",
"f": {
"lang": "akk-x-neoass",
"form": "LUGAL",
"delim": " ",
"gdl": [
{
"s": "LUGAL",
"gdl_utf8": "𒈗",
"id": "P334176.4.4.0",
"breakStart": "1",
"o": "[",
"break": "missing",
"role": "logo",
"logolang": "sux"
}
],
"cf": "šarru",
"gw": "king",
"sense": "king",
"norm": "šarri",
"pos": "N",
"epos": "N"
}
},
{
"node": "l",
"frag": "EN-ia]",
"id": "P334176.l0325e",
"ref": "P334176.4.5",
"inst": "bēlīya[lord]N",
"sig": "@saao/saa01%akk-x-neoass:EN-ia=bēlu[lord//lord]N'N$bēlīya",
"f": {
"lang": "akk-x-neoass",
"form": "EN-ia",
"gdl": [
{
"s": "EN",
"gdl_utf8": "𒂗",
"id": "P334176.4.5.0",
"break": "missing",
"role": "logo",
"logolang": "sux",
"delim": "-"
},
{
"v": "ia",
"gdl_utf8": "𒅀",
"id": "P334176.4.5.1",
"break": "missing",
"o": "]",
"breakEnd": "P334176.4.4.0"
}
],
"cf": "bēlu",
"gw": "lord",
"sense": "lord",
"norm": "bēlīya",
"pos": "N",
"epos": "N"
}
},
{
"node": "d",
"type": "nonx",
"ref": "P334176.5",
"strict": "0",
"extent": "rest",
"state": "missing"
},
{
"node": "d",
"subtype": "reverse",
"type": "reverse",
"ref": "P334176.r.6",
"label": "r"
},
{
"node": "d",
"type": "nonx",
"ref": "P334176.7",
"strict": "0",
"state": "other"
}
]
}
]
}
]
}
]
}
"""
