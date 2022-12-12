
unit Simple;
interface

{
  Automatically converted by H2Pas 1.0.0 from /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw/Simple.h
  The following command line parameters were used:
    /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw/Simple.h
    -p
    -T
    -S
    -d
    -c
    -o
    /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw/Simple.pp
}

{ Pointers to basic pascal types, inserted by h2pas conversion program.}
Type
  PLongint  = ^Longint;
  PSmallInt = ^SmallInt;
  PByte     = ^Byte;
  PWord     = ^Word;
  PDWord    = ^DWord;
  PDouble   = ^Double;

Type
PSimpleClassRec  = ^SimpleClassRec;
PSimpleRec  = ^SimpleRec;
PSimpleWidget  = ^SimpleWidget;
PSimpleWidgetClass  = ^SimpleWidgetClass;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}



{$ifndef _Simple_h}
{$define _Simple_h}
{$include <X11/Xmu/Converters.h>}


const
  XtNcursor = 'cursor';  
  XtNcursorName = 'cursorName';  
  XtNinsensitiveBorder = 'insensitiveBorder';  
  XtCInsensitive = 'Insensitive';  
{$ifndef XtCInternational}

const
  XtCInternational = 'International';  
{$endif}
{$ifndef XtNinternational}

const
  XtNinternational = 'international';  
{$endif}
{$ifndef OLDXAW}
{$ifndef XawNdisplayList}

const
  XawNdisplayList = 'displayList';  
{$endif}
{$ifndef XawCDisplayList}

const
  XawCDisplayList = 'DisplayList';  
{$endif}
{$ifndef XawRDisplayList}

const
  XawRDisplayList = 'XawDisplayList';  
{$endif}

const
  XtNtip = 'tip';  
  XtCTip = 'Tip';  
{$endif}

type
  PSimpleWidgetClass = ^TSimpleWidgetClass;
  TSimpleWidgetClass = PSimpleClassRec;

  PSimpleWidget = ^TSimpleWidget;
  TSimpleWidget = PSimpleRec;
  var
    simpleWidgetClass : TWidgetClass;cvar;external;
{$endif}


implementation


end.
