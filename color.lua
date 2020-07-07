Color = Object:extend()

function Color:new()
	self.type = "Color"

	-- self.gold = {255,215,0,1}
	-- self.magenta = {255,0,255,1}
	-- self.sienna = {160,82,45,1}
	-- self.forestgreen = {34,139,34,1}
	-- self.azure = {240,255,255,1}
	-- self.dimgrey = {105,105,105,1}
	-- self.lawngreen = {124,252,0,1}
	-- self.dodgerblue = {30,144,255,1}
	-- self.whitesmoke = {245,245,245,1}
	-- self.khaki = {240,230,140,1}
	-- self.darkcyan = {0,139,139,1}
	-- self.violet = {238,130,238,1}
	-- self.lightskyblue = {135,206,250,1}
	-- self.aliceblue = {240,248,255,1}
	-- self.dimgray = {105,105,105,1}
	-- self.orange = {255,165,0,1}
	-- self.powderblue = {176,224,230,1}
	-- self.lightgray = {211,211,211,1}
	-- self.thistle = {216,191,216 ,1}
	-- self.lavender = {230,230,250,1}
	-- self.lightsalmon = {255,160,122,1}
	-- self.seagreen = {46,139,87,1}
	-- self.turquoise = {64,224,208,1}
	-- self.greenyellow = {173,255,47,1}
	-- self.antiquewhite = {250,235,215,1}
	-- self.palevioletred = {219,112,147,1}
	-- self.lightyellow = {255,255,224,1}
	-- self.deepskyblue = {0,191,255,1}
	-- self.aquamarine = {127,255,212,1}
	-- self.palegreen = {152,251,152,1}
	-- self.lightcoral = {240,128,128,1}
	-- self.lime = {0,255,0,1}
	-- self.lightpink = {255,182,193,1}
	-- self.darkslategray = {47,79,79,1}
	-- self.gainsboro = {220,220,220,1}
	-- self.springgreen = {0,255,127,1}
	-- self.darkgray = {169,169,169,1}
	-- self.tan = {210,180,140,1}
	-- self.papayawhip = {255,239,213,1}
	-- self.chartreuse = {127,255,0,1}
	-- self.midnightblue = {25,25,112,1}
	-- self.steelblue = {70,130,180,1}
	-- self.yellowgreen = {154,205,50,1}
	-- self.lightgoldenrodyellow = {250,250,210,1}
	-- self.rosybrown = {188,143,143,1}
	-- self.darkgoldenrod = {184,134,11,1}
	-- self.tomato = {255,99,71,1}
	-- self.linen = {250,240,230,1}
	-- self.blue = {0,0,255,1}
	-- self.mintcream = {245,255,250,1}
	-- self.mediumpurple = {147,112,219,1}
	-- self.oldlace = {253,245,230,1}
	-- self.cornflowerblue = {100,149,237,1}
	-- self.slategray = {112,128,144,1}
	-- self.orchid = {218,112,214,1}
	-- self.lemonchiffon = {255,250,205,1}
	-- self.mediumaquamarine = {102,205,170,1}
	-- self.lightcyan = {224,255,255,1}
	-- self.slateblue = {106,90,205,1}
	-- self.firebrick = {178,34,34,1}
	-- self.pink = {255,192,203,1}
	-- self.royalblue = {65,105,225,1}
	-- self.saddlebrown = {139,69,19,1}
	-- self.mediumorchid = {186,85,211,1}
	-- self.blanchedalmond = {255,235,205,1}
	-- self.plum = {221,160,221,1}
	-- self.navajowhite = {255,222,173,1}
	-- self.olivedrab = {107,142,35,1}
	-- self.deeppink = {255,20,147,1}
	-- self.mediumspringgreen = {0,250,154,1}
	-- self.darkred = {139,0,0,1}
	-- self.aqua = {0,255,255,1}
	-- self.brown = {165,42,42,1}
	-- self.lightsteelblue = {176,196,222,1}
	-- self.skyblue = {135,206,235,1}
	-- self.lightblue = {173,216,230,1}
	-- self.snow = {255,250,250,1}
	-- self.orangered = {255,69,0,1}
	-- self.sandybrown = {244,164,96,1}
	-- self.crimson = {220,20,60,1}
	-- self.lavenderblush = {255,240,245,1}
	-- self.mediumvioletred = {199,21,133,1}
	-- self.coral = {255,127,80,1}
	-- self.lightslategray = {119,136,153,1}
	-- self.darkblue = {0,0,139,1}
	-- self.limegreen = {50,205,50,1}
	-- self.ghostwhite = {248,248,255,1}
	-- self.darkorchid = {153,50,204,1}
	-- self.navy = {0,0,128,1}
	-- self.lightgreen = {144,238,144,1}
	-- self.goldenrod = {218,165,32,1}
	-- self.rebeccapurple = {102,51,153,1}
	-- self.floralwhite = {255,250,240,1}
	-- self.seashell = {255,245,238,1}
	-- self.mediumturquoise = {72,209,204,1}
	-- self.burlywood = {222,184,135,1}
	-- self.blueviolet = {138,43,226,1}
	-- self.mediumslateblue = {123,104,238,1}
	-- self.lightslategrey = {211,211,211,1}
	-- self.indianred = {205,92,92,1}
	-- self.darkseagreen = {143,188,143,1}
	-- self.teal = {0,128,128,1}
	-- self.mistyrose = {255,228,225,1}
	-- self.silver = {192,192,192,1}
	-- self.darkviolet = {148,0,211,1}
	-- self.mediumblue = {0,0,205,1}
	-- self.peru = {205,133,63,1}
	-- self.fuchsia = {255,0,255,1}
	-- self.darkorange = {255,140,0,1}
	-- self.darkkhaki = {189,183,107,1}
	-- self.chocolate = {210,105,30,1}
	-- self.beige = {245,245,220,1}
	-- self.wheat = {245,222,179,1}
	-- self.lightseagreen = {32,178,170,1}
	-- self.darkmagenta = {139,0,139,1}
	-- self.cadetblue = {95,158,160,1}
	-- self.slategrey = {112,128,144,1}
	-- self.darkslategrey = {47,79,79,1}
	-- self.moccasin = {255,228,181,1}
	-- self.darkturquoise = {0,206,209,1}
	-- self.cornsilk = {255,248,220,1}
	-- self.darkolivegreen = {85,107,47,1}
	-- self.mediumseagreen = {60,179,113,1}
	-- self.paleturquoise = {175,238,238,1}
	-- self.bisque = {255,228,196,1}
	-- self.darkslateblue = {72,61,139,1}
	-- self.palegoldenrod = {238,232,170,1}
	-- self.darkgreen = {0,100,0,1}
	-- self.hotpink = {255,105,180,1}
	-- self.peachpuff = {255,218,185,1}
	-- self.darksalmon = {233,150,122,1}
	self.black = {0, 0, 0}
	self.canary = {1, 1, 153/255}
	self.cherry = {222/255, 49/255, 99/255}
	self.corn = {251/255, 236/255, 93/255}
	self.cornflower = {154/25, 206/255, 235/255}
	self.cream = {1, 253/255, 208/255}
	self.cyan = {0, 1, 1}
	self.darkGray = {169/255, 169/255, 169/255}
	self.eggShell = {240/255, 234/255, 214/255}
	self.emerald = {80/255, 200/255, 120/255}
	self.grey = {128/255, 128/255, 128/255}
	self.gray = {128/255, 128/255, 128/255}
	self.green = {0, 128/255, 0}
	self.iris = {90/255, 79/255, 207/255}
	self.indigo = {75/255, 0, 130/255}
	self.ivory = {1, 1, 240/255}
	self.lemon = {1, 247/255, 0}
	self.lightGrey = {211/255, 211/255, 211/255}
	self.maroon = {128/255, 0, 0}
	self.olive = {128/255, 128/255, 0}
	self.purple = {128/255, 0, 128/255}
	self.red = {1, 0, 0}
	self.salmon = {250/255, 128/255, 114/255}
	self.scarlet = {1, 36/255, 0}
	self.vermilion = {227/255, 66/255, 52/255}
	self.yellow = {1, 1, 0}
	self.white = {1, 1, 1}
end