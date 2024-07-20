/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>
/* appearance */
static const unsigned int borderpx  = 0;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 1;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "CaskaydiaCove Nerd Font Mono:size=10" };
static const char dmenufont[]       = "CaskaydiaCove Nerd Font Mono:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#007733";
static const unsigned int baralpha = 0xd0;
static const unsigned int borderalpha = OPAQUE;
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};
static const unsigned int alphas[][3]      = {
    /*               fg      bg        border*/
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha, borderalpha },
};

static const char *const autostart[] = {
	"dwmblocks", NULL,
//	"/home/nolan/dwm/display-off", NULL,
//	"picom", NULL,
//	"xpolkit", NULL,
//	"nitrogen", "--restore", NULL,
//	"gnome-keyring-daemon", "--start", NULL,
	NULL /* terminate */
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "com-atlauncher-App", NULL, NULL,   0,            1,           -1 },
	{ NULL,       NULL,       NULL,       0,            0,            -1} // default
};
/* window swallowing */
static const int swaldecay = 3;
static const int swalretroactive = 1;
static const char swalsymbol[] = "!";

/* window following */
#define WFACTIVE '>'
#define WFINACTIVE 'v'
#define WFDEFAULT WFINACTIVE

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-g", "5", "-l", "10", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "kitty", NULL };
static const char roficmd[] = "rofi -show combi -combi-modes 'window,drun' -modes 'combi,filebrowser,run'";

#include "movestack.c"
static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },		// terminal
	{ MODKEY,                       XK_b,      togglebar,      {0} },			// toggle bar
	{ MODKEY|ShiftMask,             XK_j,      rotatestack,    {.i = +1 } },		// rotate non-master windows
	{ MODKEY|ShiftMask,             XK_k,      rotatestack,    {.i = -1 } },		// ^
	{ MODKEY,                       XK_n,      togglefollow,   {0} },			// toggle window following
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },		// move between windows
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },		// ^
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },		// change number of master windows
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },		// ^
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },		// change size
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },		// ^
	{ MODKEY|ShiftMask,             XK_h,      setcfact,       {.f = +0.25} },		// change size more
	{ MODKEY|ShiftMask,             XK_l,      setcfact,       {.f = -0.25} },		// ^
	{ MODKEY|ShiftMask,             XK_o,      setcfact,       {.f =  0.00} },		// reset size
	{ MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },		// move windows
	{ MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },		// ^
	{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },			// zoom
	{ MODKEY,                       XK_Tab,    view,           {0} },			// view
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },			// kill
//	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },	// tile layout
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },	// floating layout
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },	// monocle layout
	{ MODKEY,                       XK_space,  setlayout,      {0} },			// swap between tile/floating
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },			// toggle current window floating
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },		// show all tags
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },		// show current window on all tags
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },		// focus on other monitors
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },		// ^
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },		// move between other monitors
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },		// ^
	{ MODKEY,                       XK_u,      swalstopsel,    {0} },			// stop swallowing
	{ MODKEY,                       XK_q,      quit,           {0} },			// restart dwm
	{ MODKEY|ShiftMask,             XK_q,      spawn,          SHCMD("pkill Xorg") },	// quit dwm
	
	{ Mod1Mask,                     XK_space,  spawn,          SHCMD(roficmd) },		// rofi
	{ MODKEY,                       XK_e,      spawn,          SHCMD("nemo") },
	{ MODKEY,                       XK_j,      spawn,          SHCMD("/home/nolan/Apps/Joplin-2.14.22.AppImage") },
	{ MODKEY,                       XK_t,      spawn,          SHCMD("google-chrome-stable --profile-directory=Default") },
	{ MODKEY|ShiftMask,             XK_t,      spawn,          SHCMD("google-chrome-stable --profile-directory='Profile 1'") },
	{ MODKEY|Mod1Mask,              XK_t,      spawn,          SHCMD("google-chrome-stable --profile-directory='Profile 2'") },
	{ 0,                            XF86XK_AudioRaiseVolume,spawn,SHCMD("amixer -D pipewire set Master 5%+") }, //increase audio volume, you muse use PulseAudio for this to work
	{ 0,                            XF86XK_AudioLowerVolume,spawn,SHCMD("amixer -D pipewire set Master 5%-") }, //decrease audio-volume
	{ 0,                            XF86XK_AudioMute, spawn,   SHCMD("amixer -D pipewire set Master toggle") }, //mute audio-volume
	{MODKEY,                        XK_p,       spawn,         SHCMD("scrot -fs temp.png -e 'xclip -selection clipboard -target image/png -i $f ; rm $f'")}, 
	{MODKEY|ShiftMask,              XK_p,       spawn,         SHCMD("scrot -fs ~/Pictures/%d-%m-%y-%H%M%S.png")},
	{MODKEY,                        XK_o,       spawn,         SHCMD("scrot temp.png -e 'xclip -selection clipboard -target image/png -i $f ; rm $f'")},
	{MODKEY|ShiftMask,              XK_o,       spawn,         SHCMD("scrot ~/Pictures/%d-%m-%y-%H%M%S.png")},
	{MODKEY|ControlMask,            XK_p,       spawn,         SHCMD("/home/nolan/scripts/ocrshot.sh")},

	TAGKEYS(                        XK_1,                      0)				// tag keys
	TAGKEYS(                        XK_2,                      1)				// ^
	TAGKEYS(                        XK_3,                      2)				// ^
	TAGKEYS(                        XK_4,                      3)				// ^
	TAGKEYS(                        XK_5,                      4)				// ^
	

};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkFollowSymbol,      0,              Button1,        togglefollow,   {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkClientWin,         MODKEY|ShiftMask, Button1,      swalmouse,      {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

