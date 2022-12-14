/* $Id: Checkbox.c,v 1.1 1997/08/27 06:40:44 falk Exp $
 *
 * Checkbox.c - Checkbox button widget
 *
 * Author: Edward A. Falk
 *         falk@falconer.vip.best.com
 *  
 * Date:   June 30, 1997
 *
 * Overview:  This widget is identical to the Radio widget in behavior,
 * except that the button is square and has a check mark.
 *
 * $Log: Checkbox.c,v $
 * Revision 1.1  1997/08/27 06:40:44  falk
 * Initial revision
 *
 */


#include <stdio.h>

#include <X11/IntrinsicP.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/XawInit.h>
#include <X11/Xmu/Converters.h>
#include <X11/Xmu/Misc.h>
#include "CheckboxP.h"


/* by using the same size for the checkbox as for the diamond box,
 * we can let the Radio widget do the vast majority of the work.
 */

#define	BOX_SIZE	8
#define	DRAW_CHECK	0	/* don't draw the check mark */

#define	cclass(w)	((CheckboxWidgetClass)((w)->core.widget_class))

#ifdef	_ThreeDP_h
#define	swid(cw)	((cw)->threeD.shadow_width)
#else
#define	swid(cw)	((cw)->core.border_width)
#endif

#define	bsize(cw)	(cclass(cw)->radio_class.dsize)
#define	bs(cw)		(bsize(cw) + 2*swid(cw))


#if	DRAW_CHECK
#define check_width 14
#define check_height 14
static u_char check_bits[] = {
   0x00, 0x00, 0x00, 0x20, 0x00, 0x18, 0x00, 0x0c, 0x00, 0x06, 0x00, 0x03,
   0x8c, 0x03, 0xde, 0x01, 0xff, 0x01, 0xfe, 0x00, 0xfc, 0x00, 0x78, 0x00,
   0x70, 0x00, 0x20, 0x00};
#endif


/****************************************************************
 *
 * Full class record constant
 *
 ****************************************************************/


#if DRAW_CHECK
static char defaultTranslations[] =
    "<EnterWindow>:	highlight()\n\
     <LeaveWindow>:	unpress(draw) unhighlight()\n\
     <Btn1Down>:	press()\n\
     <Btn1Down>,<Btn1Up>:   unpress(nodraw) toggle() notify()";
#endif



#define	offset(field)	XtOffsetOf(CheckboxRec, field)
static	XtResource	resources[] = {
  {XtNtristate, XtCTristate, XtRBoolean, sizeof(Boolean),
    offset(checkbox.tristate), XtRImmediate, (XtPointer)FALSE},
} ;
#undef	offset

	/* Member functions */

static	void	CheckboxClassInit() ;
static	void	CheckboxInit(), CheckboxRealize() ;
static	void	DrawCheck() ;


	/* Action procs */

static	void	CheckboxPress(), CheckboxUnpress() ;
extern	void	RadioSet(), RadioUnset() ;


	/* internal privates */

static	void	CheckboxSize() ;		/* find ideal size for widget */



#if DRAW_CHECK
static	XtActionsRec	actionsList[] =
{
  {"press",	CheckboxPress},
  {"unpress",	CheckboxUnpress},
} ;
#endif

#define SuperClass ((RadioWidgetClass)&radioClassRec)

CheckboxClassRec checkboxClassRec = {
  {
    (WidgetClass) SuperClass,		/* superclass		*/	
    "Checkbox",				/* class_name		*/
    sizeof(CheckboxRec),		/* size			*/
    CheckboxClassInit,			/* class_initialize	*/
    NULL,				/* class_part_initialize  */
    FALSE,				/* class_inited		*/
    CheckboxInit,			/* initialize		*/
    NULL,				/* initialize_hook	*/
#if DRAW_CHECK
    CheckboxRealize,			/* realize		*/
    actionsList,			/* actions		*/
    XtNumber(actionsList),		/* num_actions		*/
#else
    XtInheritRealize,			/* realize		*/
    NULL,				/* actions		*/
    0,					/* num_actions		*/
#endif
    resources,				/* resources		*/
    XtNumber(resources),		/* resource_count	*/
    NULLQUARK,				/* xrm_class		*/
    TRUE,				/* compress_motion	*/
    TRUE,				/* compress_exposure	*/
    TRUE,				/* compress_enterleave	*/
    FALSE,				/* visible_interest	*/
    NULL,				/* destroy		*/
    XtInheritResize,			/* resize		*/
    XtInheritExpose,			/* expose		*/
    NULL,				/* set_values		*/
    NULL,				/* set_values_hook	*/
    XtInheritSetValuesAlmost,		/* set_values_almost	*/
    NULL,				/* get_values_hook	*/
    NULL,				/* accept_focus		*/
    XtVersion,				/* version		*/
    NULL,				/* callback_private	*/
#if DRAW_CHECK
    defaultTranslations,		/* tm_table		*/
#else
    XtInheritTranslations,		/* tm_table		*/
#endif
    XtInheritQueryGeometry,		/* query_geometry	*/
    XtInheritDisplayAccelerator,	/* display_accelerator	*/
    NULL				/* extension		*/
  },  /* CoreClass fields initialization */
  {
    XtInheritChangeSensitive		/* change_sensitive	*/ 
  },  /* SimpleClass fields initialization */
#ifdef	_ThreeDP_h
  {
    XtInheritXaw3dShadowDraw		/* field not used	*/
  },  /* ThreeDClass fields initialization */
#endif
  {
    0					  /* field not used	*/
  },  /* LabelClass fields initialization */
  {
    0					  /* field not used	*/
  },  /* CommandClass fields initialization */
  {
      RadioSet,				/* Set Procedure.	*/
      RadioUnset,			/* Unset Procedure.	*/
      NULL				/* extension.		*/
  },  /* ToggleClass fields initialization */
  {
      BOX_SIZE,
      DrawCheck,			/* draw procedure */
      NULL				/* extension. */
  },  /* RadioClass fields initialization */
  {
      NULL				/* extension. */
  },  /* CheckboxClass fields initialization */
};

  /* for public consumption */
WidgetClass checkboxWidgetClass = (WidgetClass) &checkboxClassRec;






/****************************************************************
 *
 * Class Methods
 *
 ****************************************************************/

static void
CheckboxClassInit()
{
  XawInitializeWidgetSet();
}


/*ARGSUSED*/
static void
CheckboxInit(request, new, args, num_args)
 Widget request, new;
 ArgList args;
 Cardinal *num_args;
{
    CheckboxWidget cw = (CheckboxWidget) new;
    CheckboxWidget cw_req = (CheckboxWidget) request;
    Dimension	w,h ;

#if DRAW_CHECK
    cw->checkbox.checkmark = None ;
    cw->checkbox.checkmark_GC = None ;
#endif
}


#if DRAW_CHECK
static void
CheckboxRealize(w, valueMask, attributes)
    Widget w ;
    Mask *valueMask ;
    XSetWindowAttributes *attributes ;
{
    CheckboxWidget cw = (CheckboxWidget) w;
    XtGCMask	value_mask, dynamic_mask, dontcare_mask ;
    XGCValues	values ;

    /* first, call superclass realize */
    (*checkboxWidgetClass->core_class.superclass->core_class.realize)
	(w, valueMask, attributes);

    /* TODO: cache this via xmu */
    if( cw->checkbox.checkmark == None )
      cw->checkbox.checkmark =
	XCreateBitmapFromData( XtDisplay(w), XtWindow(w),
		check_bits,check_width,check_height);

    values.fill_style = FillStippled ;
    values.stipple = cw->checkbox.checkmark ;
    values.foreground = cw->label.foreground ;
    value_mask = GCFillStyle | GCStipple | GCForeground ;
    dynamic_mask = GCTileStipXOrigin | GCTileStipYOrigin ;
    dontcare_mask = GCLineWidth | GCLineStyle | GCCapStyle | GCJoinStyle |
    	GCFont | GCSubwindowMode | GCGraphicsExposures |
	GCDashOffset | GCDashList | GCArcMode ;
    cw->checkbox.checkmark_GC =
      XtAllocateGC(w, 0, value_mask, &values, dynamic_mask, dontcare_mask) ;
}
#endif


/*	Function Name: CheckboxDestroy
 *	Description: Destroy Callback for checkbox widget.
 *	Arguments: w - the checkbox widget that is being destroyed.
 *                 junk, grabage - not used.
 *	Returns: none.
 */

/* ARGSUSED */
static void
CheckboxDestroy(w, junk, garbage)
Widget w;
XtPointer junk, garbage;
{
    CheckboxWidget cw = (CheckboxWidget) w;

#if DRAW_CHECK
    /* TODO: cache this via xmu */
    if( cw->checkbox.checkmark != None )
      XFreePixmap( XtDisplay(w), cw->checkbox.checkmark ) ;
    if( cw->checkbox.checkmark_GC != None )
      XtReleaseGC(w, cw->checkbox.checkmark_GC) ;
#endif
}



#if DRAW_CHECK
/************************************************************
 *
 *  Actions Procedures
 *
 ************************************************************/

/* ARGSUSED */
static	void
CheckboxPress(w,event,params,num_params)
  Widget	w;
  XEvent	*event;
  String	*params;	/* unused */
  Cardinal	*num_params;	/* unused */
{
  CheckboxWidget	cw = (CheckboxWidget) w ;
  if( !cw->checkbox.pressed ) {
    cw->checkbox.pressed = TRUE ;
    ((CheckboxWidgetClass)(w->core.widget_class))->radio_class.drawDiamond(w) ;
  }
}

static	void
CheckboxUnpress(w,event,params,num_params)
  Widget	w;
  XEvent	*event;
  String	*params;	/* unused */
  Cardinal	*num_params;	/* unused */
{
  CheckboxWidget	cw = (CheckboxWidget) w ;
  int			i ;

  if( cw->checkbox.pressed ) {
    cw->checkbox.pressed = FALSE ;
    if( *num_params > 0  &&  **params == 'd' )
      ((CheckboxWidgetClass)(w->core.widget_class))->radio_class.drawDiamond(w);
  }
}
#endif





/************************************************************
 *
 *  Internal Procedures
 *
 ************************************************************/

static	void
DrawCheck(w)
    Widget	w ;
{
	CheckboxWidget	cw = (CheckboxWidget) w ;
	Display		*dpy = XtDisplay(w) ;
	Window		win = XtWindow(w) ;
	GC		gc ;

	XPoint		pts[6] ;
	Dimension	s = swid(cw);
	Dimension	bsz = bsize(cw);
	Position	bx,by ;		/* Check upper-left */
	Dimension	bw,bh ;
	GC		top, bot, ctr ;

	/* foreground GC */
	gc = XtIsSensitive(w) ? cw->command.normal_GC : cw->label.gray_GC ;

	bw = bh = bs(cw) ;
	bx = cw->label.internal_width ;
	by = cw->core.height/2 - bh/2 ;

#ifdef	_ThreeDP_h
	if( !cw->command.set ) {
	  top = cw->threeD.top_shadow_GC ;
	  bot = cw->threeD.bot_shadow_GC ;
	} else {
	  top = cw->threeD.bot_shadow_GC ;
	  bot = cw->threeD.top_shadow_GC ;
	}
	ctr = cw->command.inverse_GC ;
#else
	ctr = cw->command.set ? cw->command.normal_GC : cw->command.inverse_GC ;
#endif

	XFillRectangle(dpy,win,ctr, bx+s,by+s, bsz,bsz) ;

#ifdef	_ThreeDP_h
	/* top-left shadow */
	pts[0].x = bx ;		pts[0].y = by ;
	pts[1].x = bw ;		pts[1].y = 0 ;
	pts[2].x = -s ;		pts[2].y = s ;
	pts[3].x = -bsz ;	pts[3].y = 0 ;
	pts[4].x = 0 ;		pts[4].y = bsz ;
	pts[5].x = -s ;		pts[5].y = s ;
	XFillPolygon(dpy,win,top, pts,6, Nonconvex,CoordModePrevious) ;
	/* bottom-right shadow */
	pts[0].x = bx+bw ;	pts[0].y = by+bh ;
	pts[1].x = -bw ;	pts[1].y = 0 ;
	pts[2].x = s ;		pts[2].y = -s ;
	pts[3].x = bsz ;	pts[3].y = 0 ;
	pts[4].x = 0 ;		pts[4].y = -bsz ;
	pts[5].x = s ;		pts[5].y = -s ;
	XFillPolygon(dpy,win,bot, pts,6, Nonconvex,CoordModePrevious) ;
#else
	XDrawRectangle(dpy,win,gc, bx+s,by+s, bsz,bsz) ;
#endif

#if DRAW_CHECK
	if( cw->command.set && cw->checkbox.checkmark_GC != None ) {
	  XSetTSOrigin(dpy,cw->checkbox.checkmark_GC, bx+s, by+s) ;
	  XFillRectangle(dpy,win,cw->checkbox.checkmark_GC,
	  	bx+s, by+s, check_width,check_height) ;
	}
#endif
}
