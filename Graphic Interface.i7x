Version 1 of Graphic Interface (for Glulx only) by Mangouste begins here.

"Provides a graphics window in one part of the screen, in which the author can place images; with provision for scaling, tiling, or centering images automatically, as well as setting a background color. Glulx only.
Massively based on Simple Graphical Window by Emily Short."

Include Version 6 of Glulx Entry Points by Emily Short.

Section 1 - Creating Rocks and Building the Window Itself

Include(-  

Constant GG_LOCWIN_ROCK = 200;
Global gg_locwin = 0; 
Constant GG_MENUWIN_ROCK = 220;
Global gg_menuwin = 0; 
Constant GG_HEADWIN_ROCK = 221;
Global gg_headwin = 0;
Constant GG_DESCWIN_ROCK = 222;
Global gg_descwin = 0; 
Constant GG_NAMEWIN_ROCK = 223;
Global gg_namewin = 0; 

-) before "Glulx.i6t".   

Before starting the virtual machine:
	do nothing. [Hack that, for complicated reasons, prevents character streams going to the wrong place at game startup under some conditions.]

When play begins (this is the graphics window construction rule):
	build graphic interface;
	follow the current graphics drawing rule.


Section 2 - Items to slot into HandleGlkEvent and IdentifyGlkObject

[These rules belong to rulebooks defined in Glulx Entry Points.]

A glulx zeroing-reference rule (this is the default removing reference to locwin rule):
	zero locwin.

To zero locwin:
	(- gg_locwin = 0; -)

A glulx resetting-windows rule (this is the default choosing locwin rule):
	identify glulx rocks.	

To identify glulx rocks:
	(- RockSwitchingSGW(); -)

Include (-

[ RockSwitchingSGW;
	switch( (+current glulx rock+) )
	{
		GG_LOCWIN_ROCK: gg_locwin = (+ current glulx rock-ref +);
	}
];

-)

A glulx arranging rule (this is the default arranging behavior rule): 
	follow the current graphics drawing rule.

A glulx redrawing rule (this is the default redrawing behavior rule):
	follow the current graphics drawing rule.

A glulx object-updating rule (this is the automatic redrawing window rule):
	follow the current graphics drawing rule.

Section 3 - Inform 6 Routines for Drawing In Window

Include (-  

[ FindHeight  result graph_height;
	if (gg_locwin)
	{	result = glk_window_get_size(gg_locwin, gg_arguments, gg_arguments+WORDSIZE);
             		graph_height  = gg_arguments-->1;
	} 
	return graph_height;
];

[ FindWidth  result graph_width;
	if (gg_locwin)
	{	result = glk_window_get_size(gg_locwin, gg_arguments, gg_arguments+WORDSIZE);
             		graph_width  = gg_arguments-->0;
	} 
	return graph_width;
];

 [ MyRedrawGraphicsWindows window cur_pic result graph_width graph_height 
		img_width img_height w_offset h_offset w_total h_total;

	if (FollowRulebook( (+glulx picture selection rules+) ) ) { cur_pic = ResourceIDsOfFigures-->(+ internally selected picture +); }   
	if (cur_pic == 0) rtrue;

      if (window) {  

	result = glk_window_get_size(window, gg_arguments, gg_arguments+WORDSIZE);
             	graph_width  = gg_arguments-->0;
             	graph_height = gg_arguments-->1;

	result = glk_image_get_info( cur_pic, gg_arguments,  gg_arguments+WORDSIZE);
	img_width  = gg_arguments-->0;
	img_height = gg_arguments-->1;

	w_total = img_width;
	h_total = img_height;

	if (graph_height - h_total < 0) !	if the image won't fit, find the scaling factor
	{
		w_total = (graph_height * w_total)/h_total;
		h_total = graph_height;

	}

	if (graph_width - w_total < 0)
	{
		h_total = (graph_width * h_total)/w_total;
		w_total = graph_width;
	}

	w_offset = (graph_width - w_total)/2; if (w_offset < 0) w_offset = 0;
	h_offset = (graph_height - h_total)/2; if (h_offset < 0) h_offset = 0;

	glk_image_draw_scaled(window, cur_pic, w_offset, h_offset, w_total, h_total); 
	}
 ]; 

[ BlankWindowToColor color result graph_width graph_height;
  
	 color = (+ assigned number of graphics background color +);
	if (color == 0) color = $000000;

      if (gg_locwin) {  

	result = glk_window_get_size(gg_locwin, gg_arguments, gg_arguments+WORDSIZE);
             	graph_width  = gg_arguments-->0;
             	graph_height = gg_arguments-->1; 

	glk_window_fill_rect(gg_locwin, color , 0, 0, graph_width, graph_height);
	}
];

 [ TileFillGraphicsWindows cur_pic result graph_width graph_height 
		img_width img_height w_total h_total color window;

	if (FollowRulebook( (+glulx picture selection rules+) ) ) { cur_pic = ResourceIDsOfFigures-->(+ internally selected picture +); }   
	if (cur_pic == 0) rtrue;

	color = (+ assigned number of graphics background color +);
	if (color == 0) color = $000000;

      if (gg_locwin) {  

	result = glk_window_get_size(gg_locwin, gg_arguments, gg_arguments+WORDSIZE);
             	graph_width  = gg_arguments-->0;
             	graph_height = gg_arguments-->1;

	result = glk_image_get_info( cur_pic, gg_arguments,  gg_arguments+WORDSIZE);
	img_width  = gg_arguments-->0;
	img_height = gg_arguments-->1;   

	while (w_total < graph_width)
	{
		while (h_total < graph_height)
		{
			glk_image_draw(gg_locwin, cur_pic, w_total, h_total); 
			h_total = h_total + img_height;
		}
		h_total = 0;
		w_total = w_total + img_width;
	}
	}
 ]; 

[ TotalFillGraphicsWindows cur_pic result graph_width graph_height 
		img_width img_height;

	if (FollowRulebook( (+glulx picture selection rules+) ) ) { cur_pic =  ResourceIDsOfFigures-->(+ internally selected picture +); }   
	if (cur_pic == 0) rtrue;

      if (gg_locwin) {  

	result = glk_window_get_size(gg_locwin, gg_arguments, gg_arguments+WORDSIZE);
             	graph_width  = gg_arguments-->0;
             	graph_height = gg_arguments-->1;

	glk_image_draw_scaled(gg_locwin, cur_pic, 0, 0, graph_width, graph_height); 
	}
 ]; 

!Array gg_arguments --> 0 0;

[ MakeGraphicsWindow depth prop pos;
	if (gg_locwin) rtrue;
	depth = (+ Graphics window pixel count +);
	prop = (+ Graphics window proportion +);
	pos = (+ Graphics window position +);
	switch(pos)
	{
		(+g-null+): pos = winmethod_Above;
		(+g-above+): pos = winmethod_Above;
		(+g-below+): pos = winmethod_Below;
		(+g-left+): pos = winmethod_Left;
		(+g-right+): pos = winmethod_Right;
	} 
	if (prop > 0 && prop < 100)
	{	
		gg_locwin = glk_window_open(gg_mainwin, (pos+winmethod_Proportional), prop, wintype_Graphics, GG_LOCWIN_ROCK);
	}
	else
	{
		if (depth == 0) depth = 240;
		gg_locwin = glk_window_open(gg_mainwin, (pos+winmethod_Fixed), depth, wintype_Graphics, GG_LOCWIN_ROCK);
	}
];

[ MakeGraphicInterface depth prop pos;
	if (gg_locwin) rtrue;
	gg_menuwin = glk_window_open(gg_mainwin, (winmethod_Right+winmethod_Proportional), 33, wintype_Textbuffer, GG_MENUWIN_ROCK);
	gg_locwin = glk_window_open(gg_mainwin, (winmethod_Above+winmethod_Proportional), 50, wintype_Graphics, GG_LOCWIN_ROCK);
	gg_descwin = glk_window_open(gg_menuwin, (winmethod_Above+winmethod_Fixed), 20, wintype_Textbuffer, GG_DESCWIN_ROCK);
	!gg_namewin = glk_window_open(gg_descwin, (winmethod_Above+winmethod_Fixed), 15, wintype_TextGrid, GG_NAMEWIN_ROCK);
	!gg_descwin = glk_window_open(gg_descwin, (winmethod_above+winmethod_Fixed), 300, wintype_Graphics, GG_DESCWIN_ROCK);
	!ClearWindow(gg_headwin);
];

[ ClearWindow win;
	glk_window_set_background_color(win,$00000000);
	glk_window_clear(win);
];

!Array gg_arguments --> 0 0;

-). 

Section 4 - Inform 7 Wrappers for Defining Window and Colors

Include Glulx Text Effects by Emily Short. [This makes colors available to us.]

Currently shown picture is a figure-name that varies. [This the author may set during the course of the source.]

Internally selected picture is a figure-name that varies. [This is the picture selected by the picture selection rules, which might be the 'currently shown picture' (by default) or might be, say, the current frame of an animation in progress. The author should not set this directly, but instead write additional picture selection rules if he wants to change it.]

Graphics window pixel count is a number that varies. Graphics window proportion is a number that varies.

Graphics background color is a glulx color value that varies.

Glulx window position is a kind of value. The Glulx window positions are g-null, g-above, g-below, g-left, and g-right.

Graphics window position is Glulx window position that varies.  


Section 4a - More Wrappers (for use without Collage Tools by Emily Short)

To decide what number is the current graphics window width:
	(- FindWidth() -)

To decide what number is the current graphics window height:
	(- FindHeight() -)

To color the/-- graphics window (gcv - a glulx color value) from (x - a number) by (y - a number) to (xx - a number) by (yy - a number):
	let numerical gcv be the assigned number of gcv;
	color graphics window numerical gcv from x by y to xx by yy.

To color the/-- graphics window (gcv - a number) from (x - a number) by (y - a number) to (xx - a number) by (yy - a number):
	 (- glk_window_fill_rect(gg_locwin, {gcv} , {X}, {Y}, {XX}, {YY}); -)

To draw (fig - a figure-name) from (x - a number) by (y - a number) to (xx - a number) by (yy - a number): 
	(- glk_image_draw_scaled(gg_locwin, ResourceIDsOfFigures-->{fig}, {x}, {y}, {xx}, {yy}); -)


Section 5 - Inform 7 Wrapper Rulebook for Picture Selection

The glulx picture selection rules are a rulebook.

A glulx picture selection rule (this is the default picture selection rule):
	now the internally selected picture is the currently shown picture;
	rule succeeds.

A glulx picture selection rule (this is the manual picture selection rule):
	now the internally selected picture is the currently shown picture;
	rule succeeds.

Section 6 - Inform 7 Wrapper Phrases and Rules for Drawing

This is the change window rule:
	change window to menu.
[The change window rule is listed in the carry out looking rules. ]


To change window to main:
	(- glk_set_window(gg_mainwin); -).

[Menu window actions]
The menu text is a text that varies.
The menu text is "Menu text".
To change window to menu:
	(- glk_set_window(gg_menuwin); -).
To menuPrint (text - a sayable value):
	change window to menu;
	say "[text]";
	change window to main.
To TextToMenu:
	menuPrint the menu text.
To menu-clear:
	(- glk_window_clear(gg_menuwin); -).
This is the menu-clear rule:
	menu-clear.
To flush item:
	(- glk_window_flow_break(gg_menuwin); -).
This is the flush item rule:
	flush item.

[Description window actions]
The desc text is a text that varies.
The desc text is "Description text".
To change window to desc:
	(- glk_set_window(gg_descwin); -).
To descPrint (text - a sayable value):
	change window to desc;
	say "[text]";
	change window to main.
To TextToDesc:
	descPrint the desc text.
To desc-clear:
	(- glk_window_clear(gg_descwin); glk_window_flow_break(gg_descwin);-).

To desc-skipp:
	(- glk_window_flow_break(gg_descwin); -).

This is the desc-clear rule:
	desc-clear.


To loc-clear:
	(- ClearWindow(gg_locwin);-).


To build graphic interface:
	(- MakeGraphicInterface(); -)


Current graphics drawing rule is a rule that varies. The current graphics drawing rule is the standard placement rule.

[By default we want to clear the screen to the established background color, then draw our image centered in the window, scaling it down to fit if necessary.]

This is the standard placement rule:
	blank window to graphics background color;
	follow the draw locality rule. 

This is the bland graphics drawing rule:
	blank window to graphics background color;

To blank the/-- graphics/-- window to (bc - a glulx color value): 
	blank the graphics window to the assigned number of bc;

To blank the/-- graphics/-- window to (bc - a number):
	(- BlankWindowToColor({bc}); -)

[We can also use the centered scaled drawing rule on its own, without blanking out the background, if we want. This might be useful if, for instance, we want to fill the background with a tiled texture and then place a centered image over the top of it.]

This is the draw locality rule:
	draw centered scaled image in location window.

To draw centered scaled image in location window:
	(- MyRedrawGraphicsWindows(gg_locwin); -)

This is the draw desc rule:
	draw centered scaled image in desc window.

This is the draw right desc rule:
	draw right image in desc window.

To draw centered scaled image in desc window:
	(- glk_image_draw(gg_descwin, ResourceIDsOfFigures-->(+ currently shown picture +),  imagealign_MarginLeft, 0); -)

To draw right image in desc window:
	(- glk_image_draw(gg_descwin, ResourceIDsOfFigures-->(+ currently shown picture +),  imagealign_MarginRight, 0); -)

This is the line draw in desc rule:
	line draw image in desc window.

To line draw image in desc window:
	(- glk_image_draw(gg_descwin, ResourceIDsOfFigures-->(+ currently shown picture +),  imagealign_InlineCenter, 0); -)

This is the draw menu rule:
	draw centered scaled image in menu window.

To draw centered scaled image in menu window:
	(- glk_image_draw(gg_menuwin, ResourceIDsOfFigures-->(+ currently shown picture +),  imagealign_InlineCenter, 0); -)

[And here's the rule for tiling an image:]

This is the tiled drawing rule:
	draw tiled image in graphics window.

To draw tiled image in graphics window:
	(- TileFillGraphicsWindows(); -)

[And for scaling the image to fit the graphics window, without preserving aspect ratio but simply filling all the available space:]



This is the fully scaled drawing rule:
	draw fully scaled image in graphics window.

To draw fully scaled image in graphics window:
	(- TotalFillGraphicsWindows(); -)

[The purpose of this design is to allow authors to add their own rules for drawing graphics should the provided ones be thought insufficient, without needing to replace the entire extension. To do this, create a rule with a different name, a To... phrase to call an I6 function, and the I6 function itself, emulating the format used here.]

Graphic Interface ends here.
